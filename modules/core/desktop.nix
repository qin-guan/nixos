{ config, lib, pkgs, ... }:

let
  desktop = config.my.desktop;
in
{
  options.my.desktop = lib.mkOption {
    type = lib.types.enum [
      "gnome"
      "plasma"
      "cosmic"
    ];
    default = "gnome";
    description = ''
      Which desktop environment to use. Switch it in hosts/<host>/default.nix
      and rebuild; the matching Home Manager config follows automatically.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (desktop == "gnome") {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      environment.systemPackages = with pkgs; [
        # Themes the app titlebars
        qadwaitadecorations
        qadwaitadecorations-qt6
        # Themes the apps
        qgnomeplatform
        qgnomeplatform-qt6
      ];
    })

    (lib.mkIf (desktop == "plasma") {
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
    })

    (lib.mkIf (desktop == "cosmic") {
      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
    })

    {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    # services.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
    };

    # Enabled for Pipewire
    security.rtkit.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    }
  ];
}
