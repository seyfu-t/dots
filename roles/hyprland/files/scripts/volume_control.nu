#!/usr/bin/env nu

def main [--inc(-i): int, --dec(-d): int] {
  if ($inc == null and $dec == null) or ($inc != null and $dec != null) {
    error make { msg: "Use exactly one of -i <n> or -d <n>" }
  }

  if $inc != null { pamixer -i $inc } else { pamixer -d $dec }

  let muted = ((pamixer --get-mute | str trim) == "true")
  let vol = (pamixer --get-volume | into int)
  let vol_human = (pamixer --get-volume-human | str trim)

  let sink_line = (pamixer --get-default-sink | lines | last)
  let sink_name = (
    $sink_line
    | split row '"'
    | where ($it | str trim | is-not-empty)
    | last
  )

  let icon = if $muted or ($vol_human | str downcase) == "muted" {
    "audio-volume-muted"
  } else if $vol < 33 {
    "audio-volume-low"
  } else if $vol < 67 {
    "audio-volume-medium"
  } else {
    "audio-volume-high"
  }

  (
      notify-send
        --app-name "volume-osd"
        --urgency normal
        --hint string:x-dunst-stack-tag:volume
        --icon $icon
        $sink_name $vol_human
  )
}
