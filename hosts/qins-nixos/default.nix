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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  # See ./users.nix and ../../modules/core/users.nix for user configuration.
  programs.zsh.enable = true;

  system.stateVersion = "26.05";
}
