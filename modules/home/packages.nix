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
    dotnet-sdk_10
    unstable.csharpier

    # NodeJS
    nodejs_24

    (pkgs.writeShellScriptBin "alta" ''
      export LD_LIBRARY_PATH=${
        pkgs.lib.makeLibraryPath (
          with pkgs;
          [
            webkitgtk_6_0
            gtk4
            pango
            harfbuzz
            gdk-pixbuf
            cairo
            vulkan-loader
            graphene
            libsoup_3
            glib
            stdenv.cc.cc.lib
          ]
        )
      }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
      export GIO_EXTRA_MODULES=${pkgs.glib-networking}/lib/gio/modules
      export XDG_DATA_DIRS=${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}
      export WEBKIT_DISABLE_DMABUF_RENDERER=1
      exec "$HOME/.dotnet/tools/alta" "$@"
    '')

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
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.droid
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gitbutler
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.but
  ];
}
