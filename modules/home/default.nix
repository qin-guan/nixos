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
    ./battery
    ./antigravity-cli.nix
    ./eza.nix
    ./gh.nix
    ./git.nix
    ./jujutsu.nix
    ./mise.nix
    ./packages.nix
    ./pi-coding-agent.nix
    ./plasma.nix
    ./sapling.nix
    ./starship.nix
    ./vscode.nix
    ./zed.nix
    ./zoxide.nix
    ./zsh.nix
  ];
  
  # dotnetup's installer drops its binary in ~/.dotnetup, outside the Nix store.
  # ~/.zshrc is generated, so the installer's "echo >> ~/.zshrc" does not persist.
  home.sessionPath = [
    "$HOME/.dotnetup"
  ];

  home.sessionVariables = {
    # DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
  };
}
