{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    libvirtd.enable = true;

    docker.enable = true;
    docker.daemon.settings = {
      bip = "172.30.0.1/16";
    };

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
