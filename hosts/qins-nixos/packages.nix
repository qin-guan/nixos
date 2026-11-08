{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox-bin
    floorp-bin
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    pkgs.unstable.mission-center
  ];
}
