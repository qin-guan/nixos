{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome

    inter
    ibm-plex
    material-icons
    maple-mono.NF

    nerd-fonts.im-writing
    nerd-fonts.blex-mono
    nerd-fonts.iosevka-term
    nerd-fonts.lilex
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-monochrome-emoji

    roboto
    roboto-mono
  ];
}
