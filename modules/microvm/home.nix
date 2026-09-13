{ username, extraZshInit }:
{ ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  programs.zsh = {
    enable = true;
    history = {
      size = 4000;
      save = 10000000;
      ignoreDups = true;
      share = false;
      append = true;
    };
    initContent = extraZshInit;
  };
  programs.home-manager.enable = true;
}
