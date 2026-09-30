{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip
    usbutils
    openssl
    nss.tools
    
    python3
  ];
}
