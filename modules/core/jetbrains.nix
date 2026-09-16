{ ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.idea
    jetbrains.webstorm
    jetbrains.goland
  ];
}
