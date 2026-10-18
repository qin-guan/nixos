{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      if [ -x '$HOME/.dotnetup/dotnetup' ]; then
        eval "$('$HOME/.dotnetup/dotnetup' env script --shell zsh --dotnet --dotnetup)"
      fi
    '';
  };
}
