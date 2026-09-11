{ pkgs, ... }:
{
  programs.antigravity-cli = {
    enable = true;
    package = pkgs.unstable.antigravity-cli;
  };
}
