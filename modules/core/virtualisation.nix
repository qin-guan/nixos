{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    libvirtd.enable = true;

    docker.enable = true;
    docker.daemon.settings.default-address-pools = [
      {
        base = "192.168.67.0/24";
        size = 24;
      }
    ];

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
    lima-full
    docker-sbx
  ];
}
