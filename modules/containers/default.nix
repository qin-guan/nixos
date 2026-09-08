{
  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  # NVIDIA CDI support for containers.
  hardware.nvidia-container-toolkit.enable = true;

  # Required for NVIDIA CDI devices with Docker.
  virtualisation.docker.daemon.settings.features.cdi = true;

}
