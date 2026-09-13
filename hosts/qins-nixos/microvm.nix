# Based on https://michael.stapelberg.ch/posts/2026-02-01-coding-agent-microvm-nix/
{
  lib,
  username,
  home-manager,
  ...
}:
let
  microvmBase = import ../../modules/microvm/base.nix;

  mkVm =
    {
      id,
      name,
      ipAddress ? "192.168.83.${toString (10 + id)}",
      tapId ? "microvm${toString id}",
      mac ? "02:00:00:00:00:${lib.fixedWidthString 2 "0" (lib.toHexString id)}",
      workspace ? "/home/${username}/microvm/${name}",
      extraZshInit ? "",
      extraModules ? [ ./microvms/${name}.nix ],
    }:
    {
      autostart = false;
      config.imports = [
        (microvmBase {
          inherit
            username
            home-manager
            ipAddress
            tapId
            mac
            workspace
            extraZshInit
            ;
          hostName = "${name}vm";
        })
      ] ++ extraModules;
    };
in
{
  # NetworkManager keeps managing the physical uplinks; networkd owns only these.
  networking.networkmanager.unmanaged = [
    "interface-name:microbr"
    "interface-name:microvm*"
  ];
  systemd.network.enable = true;
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

  microvm.vms = {
    codex = mkVm {
      id = 1;
      name = "codex";
    };
  };
}
