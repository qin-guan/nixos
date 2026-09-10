{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    mission-center
  ];
}
