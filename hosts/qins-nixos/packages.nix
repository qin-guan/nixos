{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    # pkgs.unstable.mission-center
  ];
}
