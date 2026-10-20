{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      if [ -x '/home/qinguan/.dotnetup/dotnetup' ]; then
        eval "$('/home/qinguan/.dotnetup/dotnetup' env script --shell zsh --dotnet --dotnetup)"
      fi
    '';
  };
}
