# Based on https://michael.stapelberg.ch/posts/2026-02-01-coding-agent-microvm-nix/
{
  lib,
  pkgs,
  username,
  home-manager,
  ...
}:
let
  microvmBase = import ../../modules/microvm/base.nix;

  vmList = [
    {
      id = 1;
      name = "codex";
    }
  ];

  getVmConfig = vm: rec {
    inherit (vm) id name;
    ipAddress = vm.ipAddress or "192.168.83.${toString (10 + id)}";
    tapId = "microvm${toString id}";
    mac = "02:00:00:00:00:${lib.fixedWidthString 2 "0" (lib.toHexString id)}";
    workspace = vm.workspace or "/home/${username}/microvm/${name}";
    keysDir = "/var/lib/microvm-keys/${name}";
    clientKey = "/home/${username}/.ssh/microvm_${name}_ed25519";
    extraZshInit = vm.extraZshInit or "";
    extraModules = vm.extraModules or [ ./microvms/${name}.nix ];
  };

  vms = map getVmConfig vmList;

  keyProvisionServices = lib.listToAttrs (
    map (vm: {
      name = "microvm-keys-${vm.name}";
      value = {
        description = "Provision SSH keys and workspace for microVM ${vm.name}";
        wantedBy = [ "multi-user.target" ];
        before = [
          "microvm-virtiofsd@${vm.name}.service"
          "microvm@${vm.name}.service"
        ];
        path = [
          pkgs.coreutils
          pkgs.openssh
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          set -euo pipefail

          # Ensure user .ssh directory exists
          mkdir -p "/home/${username}/.ssh"
          chown ${username}:users "/home/${username}/.ssh"
          chmod 700 "/home/${username}/.ssh"

          # Generate per-VM client key pair if not present
          if [ ! -f "${vm.clientKey}" ]; then
            ssh-keygen -t ed25519 -N "" -C "${username}@${vm.name}.microvm" -f "${vm.clientKey}"
            chown ${username}:users "${vm.clientKey}" "${vm.clientKey}.pub"
            chmod 600 "${vm.clientKey}"
            chmod 644 "${vm.clientKey}.pub"
          fi

          # Ensure keys directory for VM exists
          mkdir -p "${vm.keysDir}"
          # microvm tmpfiles may create shares as microvm:kvm; sshd requires root ownership.
          chown root:root "${vm.keysDir}"
          chmod 755 "${vm.keysDir}"

          # Generate VM host key if not present
          if [ ! -f "${vm.keysDir}/ssh_host_ed25519_key" ]; then
            ssh-keygen -t ed25519 -N "" -C "root@${vm.name}vm" -f "${vm.keysDir}/ssh_host_ed25519_key"
            chmod 600 "${vm.keysDir}/ssh_host_ed25519_key"
            chmod 644 "${vm.keysDir}/ssh_host_ed25519_key.pub"
          fi

          # Authorize the client key inside the VM
          cp "${vm.clientKey}.pub" "${vm.keysDir}/authorized_keys"
          chmod 644 "${vm.keysDir}/authorized_keys"

          # Generate known_hosts entry for host SSH client
          host_pub=$(cat "${vm.keysDir}/ssh_host_ed25519_key.pub")
          echo "${vm.name},${vm.name}.microvm,${vm.ipAddress} $host_pub" > "${vm.keysDir}/known_hosts"
          chown ${username}:users "${vm.keysDir}/known_hosts"
          chmod 644 "${vm.keysDir}/known_hosts"

          # Ensure workspace directory exists
          mkdir -p "${vm.workspace}"
          chown ${username}:users "${vm.workspace}"
        '';
      };
    }) vms
  );

  virtiofsdDropins = lib.listToAttrs (
    map (vm: {
      name = "microvm-virtiofsd@${vm.name}";
      value = {
        requires = [ "microvm-keys-${vm.name}.service" ];
        after = [ "microvm-keys-${vm.name}.service" ];
      };
    }) vms
  );
in
{
  # NetworkManager keeps managing the physical uplinks; networkd owns only these.
  networking.networkmanager.unmanaged = [
    "interface-name:microbr"
    "interface-name:microvm*"
  ];
  systemd.network.enable = true;
  systemd.network.wait-online.enable = false;
  systemd.network.netdevs."20-microbr".netdevConfig = {
    Kind = "bridge";
    Name = "microbr";
  };
  systemd.network.networks."20-microbr" = {
    matchConfig.Name = "microbr";
    address = [ "192.168.83.1/24" ];
    networkConfig.ConfigureWithoutCarrier = true;
    linkConfig.RequiredForOnline = "no";
  };
  systemd.network.networks."21-microvm-tap" = {
    matchConfig.Name = "microvm*";
    networkConfig.Bridge = "microbr";
    linkConfig.RequiredForOnline = "no";
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "microbr" ];
    # No fixed externalInterface: this laptop can use Ethernet or Wi-Fi.
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/microvm-keys 0755 root root -"
  ];

  systemd.services = keyProvisionServices // virtiofsdDropins;

  networking.hosts = lib.foldl' (
    acc: vm:
    acc
    // {
      "${vm.ipAddress}" = [
        vm.name
        "${vm.name}.microvm"
      ];
    }
  ) { } vms;

  programs.ssh.extraConfig = lib.concatMapStrings (vm: ''
    Host ${vm.name} ${vm.name}.microvm
      HostName ${vm.ipAddress}
      User ${username}
      IdentityFile ${vm.clientKey}
      IdentitiesOnly yes
      ForwardAgent no
      UserKnownHostsFile ${vm.keysDir}/known_hosts
      StrictHostKeyChecking yes
  '') vms;

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "microvm-forward";
      runtimeInputs = [ pkgs.openssh ];
      text = ''
        if (( $# < 2 )); then
          echo "Usage: microvm-forward VM PORT [PORT ...]" >&2
          echo "Forward host localhost ports to VM localhost; Ctrl-C stops forwarding." >&2
          exit 1
        fi

        vm=$1
        shift
        case "$vm" in
          ${lib.concatMapStringsSep "|" (vm: vm.name) vms}) ;;
          *) echo "Unknown microVM: $vm" >&2; exit 1 ;;
        esac

        forwards=()
        for port in "$@"; do
          if [[ ! "$port" =~ ^[0-9]{1,5}$ ]]; then
            echo "Invalid TCP port: $port" >&2
            exit 1
          fi
          port=$((10#$port))
          if (( port < 1 || port > 65535 )); then
            echo "TCP port must be between 1 and 65535: $port" >&2
            exit 1
          fi
          forwards+=(-L "127.0.0.1:$port:127.0.0.1:$port")
          forwards+=(-L "[::1]:$port:127.0.0.1:$port")
        done

        # Use an independent connection so the forwards live only as long as this command.
        exec ssh -N -T -S none \
          -o ExitOnForwardFailure=yes \
          -o ServerAliveInterval=15 -o ServerAliveCountMax=3 \
          "''${forwards[@]}" "$vm"
      '';
    })
  ];

  microvm.vms = lib.listToAttrs (
    map (vm: {
      name = vm.name;
      value = {
        autostart = false;
        config.imports = [
          (microvmBase {
            inherit username home-manager;
            inherit (vm)
              ipAddress
              tapId
              mac
              workspace
              keysDir
              extraZshInit
              ;
            hostName = "${vm.name}vm";
          })
          {
            microvm.vsock.cid = 10 + vm.id;
          }
        ] ++ vm.extraModules;
      };
    }) vms
  );
}
