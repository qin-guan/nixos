{ pkgs, ... }:

{
  # Hyprland itself and its portal come from the NixOS module
  # (programs.hyprland in modules/core/desktop.nix), so they match the system.
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    # UWSM manages the session; Home Manager's systemd integration conflicts.
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "fuzzel";
      "$files" = "nautilus";
      "$browser" = "zen";

      monitor = [ ",preferred,auto,auto" ];

      exec-once = [
        "waybar"
        "mako"
        "hyprpaper"
        "hypridle"
        "nm-applet --indicator"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "GDK_BACKEND,wayland,x11,*"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        resize_on_border = true;
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "linear,0,0,1,1"
        ];
        animation = [
          "global,1,10,default"
          "windows,1,4.79,easeOutQuint"
          "windowsOut,1,1.49,linear,popin 87%"
          "fade,1,3.03,easeOutQuint"
          "workspaces,1,1.94,easeOutQuint,slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master.new_status = "master";

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
      };

      gestures = {
        workspace_swipe = true;
      };

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, D, exec, $menu"
        "$mod, E, exec, $files"
        "$mod, B, exec, $browser"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, L, exec, loginctl lock-session"
        "$mod, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Screenshots (to clipboard / to file)
        ", Print, exec, grimblast --notify copy area"
        "SHIFT, Print, exec, grimblast --notify copysave screen"

        # Scratchpad
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Workspace scrolling
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = toString (i + 1);
            key = toString (if i == 9 then 0 else i + 1);
          in
          [
            "$mod, ${key}, workspace, ${ws}"
            "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
          ]
        ) 10
      ));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Repeat while held, also work when locked.
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppress_event maximize, class:.*"
        "float, class:(pavucontrol|nm-connection-editor|org.gnome.Calculator)"
        "float, class:(xdg-desktop-portal-gtk|polkit-gnome-authentication-agent-1)"
      ];
    };
  };

  # Waybar status bar.
  programs.waybar = {
    enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "battery"
      ];
      "hyprland/window".max-length = 60;
      clock.format = "{:%a %d %b  %H:%M}";
      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰁹" ];
        states = {
          warning = 30;
          critical = 15;
        };
      };
      network = {
        format-wifi = "󰖩 {signalStrength}%";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
        on-click = "nm-connection-editor";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
        on-click = "pavucontrol";
      };
      tray.spacing = 10;
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      window#waybar {
        background: rgba(26, 27, 38, 0.85);
        color: #c0caf5;
      }
      #workspaces button {
        padding: 0 8px;
        color: #7a7f9c;
      }
      #workspaces button.active {
        color: #7dcfff;
        border-bottom: 2px solid #7dcfff;
      }
      #clock, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }
      #battery.warning { color: #e0af68; }
      #battery.critical { color: #f7768e; }
    '';
  };

  # Lock screen.
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      background = [
        {
          color = "rgba(1a1b26ff)";
          blur_passes = 2;
        }
      ];
      input-field = [
        {
          size = "300, 50";
          position = "0, -80";
          halign = "center";
          valign = "center";
          outline_thickness = 2;
          placeholder_text = "Password";
        }
      ];
      label = [
        {
          text = "$TIME";
          font_size = 72;
          position = "0, 120";
          halign = "center";
          valign = "center";
          color = "rgba(c0caf5ff)";
        }
      ];
    };
  };

  # Idle: dim, lock, screen off, suspend.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Solid-color wallpaper; point `path` at an image to use one.
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png" ];
      wallpaper = [ ",${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png" ];
    };
  };

  # Launcher and notifications.
  programs.fuzzel.enable = true;
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 8;
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    grimblast
    networkmanagerapplet
    nautilus
    pavucontrol
    playerctl
    polkit_gnome
    wl-clipboard
  ];
}
