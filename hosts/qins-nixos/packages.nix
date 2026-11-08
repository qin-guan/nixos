{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    pkgs.unstable.mission-center
  ];
}
