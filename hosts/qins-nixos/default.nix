{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
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
  
  nix.settings.extra-substituters = [
    "https://ghostty.cachix.org"
  ];
  
  nix.settings.extra-trusted-public-keys = [
    "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
  ];

  # See ./users.nix and ../../modules/core/users.nix for user configuration.
  programs.zsh.enable = true;

  system.stateVersion = "26.05";
}
