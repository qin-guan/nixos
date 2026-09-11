{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "26.05";

  home.shellAliases = {
    ls = "eza";
    ll = "eza -la";
    la = "eza -a";
    lt = "eza --tree";
  };

  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;

  programs.home-manager.enable = true;

  imports = [
    ./antigravity.nix
    ./antigravity-cli.nix
    ./eza.nix
    ./bash.nix
    ./gh.nix
    ./git.nix
    ./jujutsu.nix
    ./mise.nix
    ./opencode.nix
    ./packages.nix
    ./plasma.nix
    ./sapling.nix
    ./starship.nix
    ./vscode.nix
    ./zoxide.nix
  ];
}
