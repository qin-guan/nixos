{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip
    usbutils
    
    typst
    python3
    dotnet-sdk_11
    nodejs_24
  ];
}
