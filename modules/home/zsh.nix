{ ... }:

{
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
        local current
        current=$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$bat/charge_types")
        printf 'Charge mode : %s\n' "$current"
        printf 'Capacity    : %s%% (%s)\n' "$(cat "$bat/capacity")" "$(cat "$bat/status")"
        if [ "$(cat /sys/class/power_supply/ADP0/online)" = 1 ]; then
          echo 'Adapter     : connected'
        else
          echo 'Adapter     : disconnected'
        fi
      }

      battery-toggle() {
        local f=/sys/class/power_supply/BAT0/charge_types
        local current target
        current=$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$f")

        case "''${1:-}" in
          "")
            case "$current" in
              Fast) target=Standard ;;
              Standard) target=Long_Life ;;
              *) target=Fast ;;
            esac
            ;;
          fast|rapid) target=Fast ;;
          standard|normal) target=Standard ;;
          long|conservative|conservation) target=Long_Life ;;
          *)
            echo 'usage: battery-toggle [fast|standard|long]' >&2
            return 1
            ;;
        esac

        echo "$target" | sudo tee "$f" >/dev/null
        printf 'Charge mode : %s\n' "$(sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$f")"
      }
    '';
  };
}
