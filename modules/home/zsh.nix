{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
    };

    syntaxHighlighting = {
      enable = true;
    };

    initExtra = ''
      # Lenovo Legion 5 15IMH05 charge-mode helpers.
      # Fast -> Rapid Charge, Normal -> Standard, Conservative -> Long_Life (~60% limit)
      _LEGION_CHARGE_TYPES=/sys/class/power_supply/BAT0/charge_types
      _LEGION_BAT=/sys/class/power_supply/BAT0
      _LEGION_ADP=/sys/class/power_supply/ADP0

      _legion_charge_available() {
        tr -d '[]' <"$_LEGION_CHARGE_TYPES"
      }

      _legion_charge_current() {
        sed -n 's/.*\[\([^]]*\)\].*/\1/p' "$_LEGION_CHARGE_TYPES"
      }

      _legion_charge_label() {
        case "$1" in
          Fast) echo "Fast" ;;
          Standard) echo "Normal" ;;
          Long_Life) echo "Conservative" ;;
          *) echo "$1" ;;
        esac
      }

      _legion_charge_from_arg() {
        case "$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr '-' '_')" in
          fast|rapid) echo Fast ;;
          normal|standard) echo Standard ;;
          conservative|conservation|long_life|longlife) echo Long_Life ;;
          *) echo "$1" ;;
        esac
      }

      _legion_charge_set() {
        local target="$1"
        if printf '%s\n' "$target" >"$_LEGION_CHARGE_TYPES" 2>/dev/null; then
          return 0
        fi
        printf '%s\n' "$target" | sudo tee "$_LEGION_CHARGE_TYPES" >/dev/null
      }

      _legion_uw_to_w() {
        awk -v u="$1" 'BEGIN { printf "%.1f", u / 1000000 }'
      }

      battery-status() {
        if [ ! -r "$_LEGION_CHARGE_TYPES" ]; then
          echo "charge_types not available at $_LEGION_CHARGE_TYPES" >&2
          return 1
        fi

        local current available label type cap status power energy_now energy_full cycles adapter
        current="$(_legion_charge_current)"
        available="$(_legion_charge_available)"
        label="$(_legion_charge_label "$current")"

        cap="$(cat "$_LEGION_BAT/capacity" 2>/dev/null)"
        status="$(cat "$_LEGION_BAT/status" 2>/dev/null)"
        power="$(_legion_uw_to_w "$(cat "$_LEGION_BAT/power_now" 2>/dev/null)")"
        energy_now="$(_legion_uw_to_w "$(cat "$_LEGION_BAT/energy_now" 2>/dev/null)")"
        energy_full="$(_legion_uw_to_w "$(cat "$_LEGION_BAT/energy_full" 2>/dev/null)")"
        cycles="$(cat "$_LEGION_BAT/cycle_count" 2>/dev/null)"

        if [ "$(cat "$_LEGION_ADP/online" 2>/dev/null)" = "1" ]; then
          adapter="connected"
        else
          adapter="disconnected"
        fi

        printf 'Charge mode : %s [%s]\n' "$label" "$current"
        printf 'Available   :'
        for type in $available; do
          printf ' %s' "$(_legion_charge_label "$type")"
        done
        printf '\n'
        printf 'Capacity    : %s%% (%s)\n' "$cap" "$status"
        printf 'Power       : %s W\n' "$power"
        printf 'Energy      : %s / %s Wh\n' "$energy_now" "$energy_full"
        printf 'Cycles      : %s\n' "$cycles"
        printf 'Adapter     : %s\n' "$adapter"
      }

      battery-toggle() {
        if [ ! -e "$_LEGION_CHARGE_TYPES" ]; then
          echo "charge_types not available at $_LEGION_CHARGE_TYPES" >&2
          return 1
        fi

        local available current target type first found
        available="$(_legion_charge_available)"
        current="$(_legion_charge_current)"

        if [ -n "''${1:-}" ]; then
          target="$(_legion_charge_from_arg "$1")"
        else
          first=""
          found=0
          target=""
          for type in $available; do
            [ -z "$first" ] && first="$type"
            if [ "$found" = 1 ]; then
              target="$type"
              break
            fi
            [ "$type" = "$current" ] && found=1
          done
          [ -z "$target" ] && target="$first"
        fi

        if [ -z "$target" ]; then
          echo "No charge types available" >&2
          return 1
        fi

        case " $available " in
          *" $target "*) ;;
          *)
            echo "Mode '$target' is not supported. Available:" >&2
            for type in $available; do
              echo "  $(_legion_charge_label "$type") ($type)" >&2
            done
            return 1
            ;;
        esac

        if ! _legion_charge_set "$target"; then
          echo "Failed to set charge type to $target" >&2
          return 1
        fi

        printf 'Charge mode : %s [%s]\n' "$(_legion_charge_label "$target")" "$target"
      }
    '';
  };
}
