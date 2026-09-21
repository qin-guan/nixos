{ inputs, pkgs, ... }:
{
  programs.mise = {
    enable = true;
    # Skip the upstream test suite so CI and local rebuilds share the same
    # cached derivation. The binary is what we install.
    package = inputs.mise.packages.${pkgs.system}.default.overrideAttrs (_: {
      doCheck = false;
    });
  };
}
