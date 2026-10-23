#!/usr/bin/env bash

set -uo pipefail

ICON_DIR="zigduck@quackhack-mcblindy.com/icons/mdi"
mkdir -p "$ICON_DIR"


icons=(
  nas
  desktop-tower
  laptop
  ceiling-light
  led-strip
  spotlight
  lightbulb
  lightbulb-multiple
  desk-lamp
  floor-lamp
  wall-sconce-round
  chandelier
  vanity-light
  lightbulb-night
  led-strip-variant
  book-open-variant
  candle
  weather-night
  motion-sensor
  smoke-detector
  water
  door
  thermometer
  water-percent
  remote
  power-socket-eu
  toggle-switch
  gesture-tap-button
  blinds

  # rooms
  bed
  food-fork-drink
  sofa
  toilet
  television
  dots-horizontal

  # devices / controls
  watch
  brightness-6
  battery
  wifi
  monitor
  monitor-clock
  microphone
  microphone-off
  volume-high
  volume-off
  amplifier
  speaker
  cast-audio
  play-pause
  cpu-64-bit
  power-sleep
  console
  vpn
  account-voice
  amplifier
  battery
  bed
  bell-ring
  blinds
  brightness-6
  cast-audio
  ceiling-light
  chandelier
  check-circle
  console
  cpu-64-bit
  desk-lamp
  desktop-tower
  door
  dots-horizontal
  ear-hearing
  food-fork-drink
  gesture-tap-button
  heart
  led-strip-variant
  microphone
  microphone-off
  monitor
  monitor-dashboard
  motion-sensor
  phone-in-talk
  play-pause
  playlist-remove
  power-sleep
  power-socket-eu
  remote
  skip-next
  skip-previous
  smoke-detector
  sofa
  speaker
  spotlight
  television
  toggle-switch
  toilet
  volume-high
  volume-off
  vpn
  wall-sconce-round
  watch
  water
  weather-night
  wifi

)


mapfile -t icons < <(printf '%s\n' "${icons[@]}" | awk '!seen[$0]++')

BASE="https://raw.githubusercontent.com/Templarian/MaterialDesign-SVG/master/svg"

ok=0
skip=0
fail=0
failed_list=()

for name in "${icons[@]}"; do
  out="$ICON_DIR/${name}-symbolic.svg"

  if [[ -s "$out" ]]; then
    printf '  skip  %s\n' "$out"
    ((skip++))
    continue
  fi

  printf '  get   %s\n' "$name"
  if curl -fsSL --retry 2 --retry-delay 1 -o "$out" "$BASE/${name}.svg"; then
    ((ok++))
  else
    printf '  FAIL  %s (not in MDI? renamed?)\n' "$name" >&2
    rm -f "$out"
    failed_list+=("$name")
    ((fail++))
  fi
done

echo
echo "Done -> downloaded: $ok   skipped: $skip   failed: $fail"
if (( fail > 0 )); then
  echo "Failed icons:"
  printf '  - %s\n' "${failed_list[@]}"
  exit 1
fi
