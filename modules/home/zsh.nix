{ pkgs, ... }:

{
  home.packages = [ pkgs.gum ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Legion 5 15IMH05 charge modes via charge_types:
    # Fast (Rapid Charge), Standard (Normal), Long_Life (Conservative, ~60%).
    initContent = ''
      battery-status() {
        local bat=/sys/class/power_supply/BAT0
        local current capacity bat_status adapter
        current=$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$bat/charge_types")
        capacity=$(cat "$bat/capacity")
        bat_status=$(cat "$bat/status")
        if [ "$(cat /sys/class/power_supply/ADP0/online)" = 1 ]; then
          adapter=connected
        else
          adapter=disconnected
        fi

        gum style \
          --border rounded \
          --padding "0 1" \
          --border-foreground 212 \
          "Charge mode : $current" \
          "Capacity    : $capacity% ($bat_status)" \
          "Adapter     : $adapter"
      }

      battery-toggle() {
        local f=/sys/class/power_supply/BAT0/charge_types
        local current target
        current=$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$f")

        case "''${1:-}" in
          "")
            target=$(
              gum choose \
                --header "Charge mode (now: $current)  Fast=Rapid  Standard=Normal  Long_Life=~60%" \
                --selected "$current" \
                Fast Standard Long_Life
            ) || return $?
            ;;
          fast|rapid) target=Fast ;;
          standard|normal) target=Standard ;;
          long|conservative|conservation) target=Long_Life ;;
          *)
            gum style --foreground 196 'usage: battery-toggle [fast|standard|long]' >&2
            return 1
            ;;
        esac

        echo "$target" | sudo tee "$f" >/dev/null
        battery-status
      }
    '';
  };
}
