# Legion 5 15IMH05 charge modes via charge_types:
# Fast (Rapid Charge), Standard (Normal), Long_Life (Conservative, ~60%).
def pick-mode [current: string] {
  let header = $"Charge mode (char lparen)now: ($current)(char rparen)  Fast=Rapid  Standard=Normal  Long_Life=~60%"
  let target = (
    ^gum choose --header $header --selected $current Fast Standard Long_Life
    | str trim
  )
  if ($target | is-empty) {
    exit 1
  }
  $target
}

def main [mode?: string] {
  let f = "/sys/class/power_supply/BAT0/charge_types"
  let current = (
    open --raw $f
    | str trim
    | str replace --regex '.*\[([^\]]*)\].*' '$1'
  )

  let target = if $mode == null {
    pick-mode $current
  } else {
    match $mode {
      "fast" | "rapid" => "Fast"
      "standard" | "normal" => "Standard"
      "long" | "conservative" | "conservation" => "Long_Life"
      _ => {
        ^gum style --foreground 196 "usage: battery-toggle [fast|standard|long]"
        exit 1
      }
    }
  }

  $"($target)\n" | ^sudo tee $f | ignore
  ^battery-status
}
