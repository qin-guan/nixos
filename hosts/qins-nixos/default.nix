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
    "https://qinguan.cachix.org"
    "https://cache.numtide.com"
  ];

  nix.settings.extra-trusted-public-keys = [
    "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    "qinguan.cachix.org-1:IT9vXH44tSLMuuB9QKnuh606L1IDrRu72rtz/kyQPTA="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  # See ./users.nix and ../../modules/core/users.nix for user configuration.
  programs.zsh.enable = true;
  
  services.udev.extraRules = ''
    # Keychron Launcher WebHID access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d044", MODE="0666", GROUP="input", TAG+="uaccess"
  '';


  system.stateVersion = "26.05";
}
