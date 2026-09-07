{ ... }:

{
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
  };

  # Enabled for Pipewire
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
