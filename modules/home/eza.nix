{ pkg, ... }:

{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;

    icons = "auto";
    git = true;
  };
}
