{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-tweaks
    refine
  ];

  # Install and enable Just Perfection in the Home Manager profile. This
  # option also writes the extension UUID to
  # org.gnome.shell.enabled-extensions, so it does not need to be listed again
  # under dconf.settings.
  programs.gnome-shell = {
    enable = true;

    extensions = [
      { package = pkgs.gnomeExtensions.just-perfection; }
    ];
  };

  # Plasma used to write `breeze_cursors`/`breeze-dark` into dconf and the GTK
  # settings files. Those themes disappeared when Plasma was disabled, leaving
  # a missing cursor theme that GNOME renders as a white/gray box. Pin the
  # themes to Adwaita, which ships with GNOME, so dconf/GTK always point at an
  # installed theme.
  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    # Plasma left these files behind with `breeze_cursors`/`breeze-dark`
    # values. Let Home Manager take them over instead of failing activation
    # with a file collision.
    gtk2.force = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    colorScheme = "dark";

    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface".monospace-font-name = "JetBrainsMono Nerd Font 10";
  };
}
