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
    # dotnet-sdk_11
    dotnet-sdk_10
    nodejs_24
  ];
}
