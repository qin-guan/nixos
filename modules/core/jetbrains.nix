{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.jetbrains.idea
    unstable.jetbrains.webstorm
    unstable.jetbrains.goland
    unstable.jetbrains.rider
  ];
}
