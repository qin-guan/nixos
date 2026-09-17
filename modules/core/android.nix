{ pkgs, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    pkgs.unstable.android-studio-full
  ];
}
