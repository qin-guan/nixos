{ pkgs, lib, ... }:

let
  gumPath = lib.makeBinPath [ pkgs.gum ];

  battery-status = pkgs.writers.writeNuBin "battery-status" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      gumPath
    ];
  } (builtins.readFile ./status.nu);

  battery-toggle = pkgs.writers.writeNuBin "battery-toggle" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        pkgs.gum
        battery-status
      ])
    ];
  } (builtins.readFile ./toggle.nu);
in
{
  home.packages = [
    battery-status
    battery-toggle
  ];
}
