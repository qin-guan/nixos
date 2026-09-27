{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
  };

  programs.nix-ld.libraries = with pkgs; [
    icu
    zlib
    openssl
    curl
    krb5
    libunwind
    stdenv.cc.cc
  ];
}
