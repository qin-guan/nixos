{
  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };
}
