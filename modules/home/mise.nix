{ pkgs, ... }:
{
  programs.mise = {
    enable = true;
    package = pkgs.unstable.mise;
  };
}
