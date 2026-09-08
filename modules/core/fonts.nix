{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome

    inter
    ibm-plex
    material-icons

    nerd-fonts.jetbrains-mono

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-monochrome-emoji

    roboto
    roboto-mono
  ];
}
