{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    gopls
    delve
    protobuf
    gnumake
    gcc
    git
    ripgrep
  ];
}
