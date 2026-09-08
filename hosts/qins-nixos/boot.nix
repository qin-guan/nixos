{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel 7.2 breaks the current NVIDIA driver because of strncpy deprecation.
  boot.kernelPackages = pkgs.linuxPackages_7_1;
}
