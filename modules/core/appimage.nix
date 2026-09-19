{ pkgs, ... }:
{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  # Also see boot.nix
}
