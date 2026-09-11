{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip

    pkgs.unstable.netbird
    pkgs.unstable.netbird-ui

    pkgs.unstable.tailscale
    pkgs.unstable.ktailctl
  ];
}
