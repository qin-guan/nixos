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

    # Ghostty
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default

    # nono
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.nono

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent
    
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gitbutler
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.but
  ];
}
