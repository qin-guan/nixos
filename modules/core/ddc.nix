{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    ddcutil
  ];
  
  hardware.i2c.enable = true;
}
