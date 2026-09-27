{ pkgs, ... }:
{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.icu ];
  }
  # Also see boot.nix
}
