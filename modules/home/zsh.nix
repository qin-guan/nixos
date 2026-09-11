{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    autosuggestion = {
      enable = true;
      highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
    
    syntaxHighlighting = {
      enable = true;
      highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
  };
}
