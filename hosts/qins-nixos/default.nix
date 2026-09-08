{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./boot.nix
    ./networking.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./home-manager.nix

    ../../modules/core
    ../../modules/drivers/nvidia-laptop.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
