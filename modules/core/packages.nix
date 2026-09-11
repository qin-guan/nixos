{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip

    pkgs.unstable.ktailctl
  ];
}
