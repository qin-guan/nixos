{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xbacklight
    ddcutil
  ];
  
  hardware.i2c.enable = true;
}
