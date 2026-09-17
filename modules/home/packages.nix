{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    tree
    tlrc

    ripgrep
    fzf
    bat
    jq

    fastfetch
    btop
    htop

    rclone
    just
    tmux

    devenv
    nixfmt
  ];
}
