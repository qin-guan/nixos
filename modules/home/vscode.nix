{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
  };

  # I decided its too much of a hassle to manage my settings using nix
}
