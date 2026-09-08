{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    tree
    tlrc

    ripgrep
    fzf
    bat
    eza

    fastfetch
    btop
    htop

    rclone
    just
    tmux

    devenv
  ];
}
