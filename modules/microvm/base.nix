{
  hostName,
  ipAddress,
  tapId,
  mac,
  workspace,
  username,
  home-manager,
  extraZshInit ? "",
}:
{ pkgs, lib, ... }:
{
  imports = [ home-manager.nixosModules.home-manager ];
  system.stateVersion = "26.05";
  networking.hostName = hostName;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import ./home.nix { inherit username extraZshInit; };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.zsh.enable = true;
  users.mutableUsers = false;
  # No interactive administrator: SSH uses a runtime-mounted public key file.
  users.allowNoPasswordLogin = true;
  users.users.${username} = {
    isNormalUser = true;
    # Match qinguan's host UID and primary group for writable virtiofs shares.
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "*";
  };
  users.groups.users.gid = 100;
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AuthorizedKeysFile = "%h/.ssh/authorized_keys /etc/ssh/host-keys/authorized_keys";
      AllowUsers = [ username ];
    };
    hostKeys = [
      {
        path = "/etc/ssh/host-keys/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  services.resolved.enable = true;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.tempAddresses = "disabled";
  systemd.network.enable = true;
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];
  systemd.network.networks."10-e" = {
    matchConfig.Name = "e*";
    address = [ "${ipAddress}/24" ];
    routes = [ { Gateway = "192.168.83.1"; } ];
  };
  # Disable firewall for faster boot and less hassle (behind host NAT).
  networking.firewall.enable = false;
  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";
  # Avoid the /nix/store unmount deadlock during shutdown (microvm.nix #170).
  systemd.mounts = [
    {
      what = "store";
      where = "/nix/store";
      overrideStrategy = "asDropin";
      unitConfig.DefaultDependencies = false;
    }
  ];

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = lib.mkDefault 8;
    mem = lib.mkDefault 4096;
    socket = "control.socket";
    writableStoreOverlay = "/nix/.rw-store";
    volumes = lib.mkDefault [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 8192;
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
      {
        proto = "virtiofs";
        tag = "ssh-keys";
        source = "${workspace}/ssh-host-keys";
        mountPoint = "/etc/ssh/host-keys";
        readOnly = true;
      }
      {
        proto = "virtiofs";
        tag = "workspace";
        source = workspace;
        mountPoint = workspace;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = tapId;
        inherit mac;
      }
    ];
  };
}
