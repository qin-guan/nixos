{ pkgs, ... }:
{
  programs.mise = {
    enable = true;
    package = inputs.mise.packages.${pkgs.system}.default;
  };
}
