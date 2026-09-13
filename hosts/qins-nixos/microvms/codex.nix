{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    ripgrep
    gnumake
    gcc
    autoconf
    automake
    texinfo
    pkg-config
    ncurses
  ];
}
