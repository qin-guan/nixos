{ pkgs, ... }:

# Scheduled maintenance, modelled on ZaneyOS (programs.nh.clean) plus an
# unattended flake upgrade.
let
  flakePath = "/mnt/SanDisk/Projects/github/qin-guan/nixos";
in
{
  programs.nh = {
    enable = true;
    flake = flakePath;

    # Weekly garbage collection via nh (keeps 5 generations / 7 days).
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 5";
    };
  };

  # Weekly store deduplication, off the hot path of builds.
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Unattended upgrade. Inputs are updated in-memory (the lock file in the
  # repo is left untouched); the new generation is activated on next boot
  # so the desktop session is never interrupted.
  system.autoUpgrade = {
    enable = true;
    flake = flakePath;
    operation = "boot";
    dates = "Sun 04:00";
    randomizedDelaySec = "30min";
    persistent = true;
    allowReboot = false;
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "--update-input"
      "home-manager"
      "--no-write-lock-file"
    ];
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
