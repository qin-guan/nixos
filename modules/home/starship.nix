{ ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    presets = [
      "nerd-font-symbols"
    ];
    
    settings = {
      add_newline = false;
    };
  };
}
