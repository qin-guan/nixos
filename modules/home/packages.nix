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
    devbox
    nixfmt

    typst
    google-chrome

    # Aspire
    inputs.aspire.packages.${pkgs.stdenv.hostPlatform.system}.aspire-cli

    # .NET
    unstable.csharpier

    # NodeJS
    nodejs_24
    
    unstable.dapr-cli
    unstable.zed-editor

    # Ghostty
    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default

    # nono
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.nono

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2-desktop
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.fx
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.amp
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.droid

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.kimi-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.dsh
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.zcode

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gitbutler
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.but
  ];
}
