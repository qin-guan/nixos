{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    presets = [
      "nerd-font-symbols"
    ];
  };
}
