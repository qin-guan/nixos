{ pkgs, ... }:
{
  programs.mise = {
    enable = true;
    package = pkgs.mise;
  };
}
