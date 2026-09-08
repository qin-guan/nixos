{ pkgs, pkgs-unstable, username, ... }: 

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.git = {
    enable = true;
    signing.format = null;

    settings = {
      user = {
        name = "Qin Guan";
        email = "helloqinguan@gmail.com";
      };

      push.default = "simple";
      init.defaultBranch = "main";
    };
  };

  programs.vscode = {
    enable = true;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
    ];
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Qin Guan";
        email = "helloqinguan@gmail.com";
      };
    };
  };

  programs.sapling = {
    enable = true;
    userName = "Qin Guan";
    userEmail = "helloqinguan@gmail.com";
  };

  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";

  programs.opencode.enable = true;
  programs.opencode.package = pkgs-unstable.opencode;
  programs.opencode.settings.permission.bash = "ask";

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

    inter
    noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif noto-fonts-color-emoji
    nerd-fonts.symbols-only     # split out of the old `nerdfonts` attr in 24.11
    nerd-fonts.jetbrains-mono
];

  fonts.fontconfig.enable = true;
}
