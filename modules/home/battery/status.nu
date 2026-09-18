# Legion 5 15IMH05: print charge mode, capacity, and adapter state.
def main [] {
  let bat = "/sys/class/power_supply/BAT0"
  let current = (
    open --raw $"($bat)/charge_types"
    | str trim
    | str replace --regex '.*\[([^\]]*)\].*' '$1'
  )
  let capacity = (open --raw $"($bat)/capacity" | str trim)
  let bat_status = (open --raw $"($bat)/status" | str trim)
  let adapter = if (open --raw /sys/class/power_supply/ADP0/online | str trim) == "1" {
    "connected"
  } else {
    "disconnected"
  }

  ^gum style --border rounded --padding "0 1" --border-foreground 212 $"Charge mode : ($current)" $"Capacity    : ($capacity)% (char lparen)($bat_status)(char rparen)" $"Adapter     : ($adapter)"
}
