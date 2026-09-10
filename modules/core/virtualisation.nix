{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    libvirtd.enable = true;

    docker.enable = true;

    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    virt-viewer
  ];

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
