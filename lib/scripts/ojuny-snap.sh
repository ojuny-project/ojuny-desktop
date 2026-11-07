#!/usr/bin/env bash
set -euo pipefail

config_file="${OJUNY_SNAP_CONFIG:-}"
if [ -z "$config_file" ]; then
  user_config="${XDG_CONFIG_HOME:-$HOME/.config}/ojuny/snap.conf"
  if [ -r "$user_config" ]; then
    config_file="$user_config"
  elif [ -r /etc/ojuny/snap.conf ]; then
    config_file=/etc/ojuny/snap.conf
  fi
fi
if [ -n "$config_file" ] && [ -r "$config_file" ]; then
  # shellcheck source=/dev/null
  . "$config_file"
fi

snap_range="${OJUNY_SNAP_RANGE:-150}"
snap_gap="${OJUNY_SNAP_GAP:-4}"
left_inset="${OJUNY_SNAP_LEFT_INSET:-3}"
right_inset="${OJUNY_SNAP_RIGHT_INSET:-3}"
top_inset="${OJUNY_SNAP_TOP_INSET:-45}"
bottom_inset="${OJUNY_SNAP_BOTTOM_INSET:-5}"

cursor="$(mmsg get cursorpos)"
cursor_x="$(jq -r '.x | floor' <<<"$cursor")"
cursor_y="$(jq -r '.y | floor' <<<"$cursor")"
monitor_name="$(jq -r '.monitor' <<<"$cursor")"

monitor="$(mmsg get monitor "$monitor_name")"
monitor_width="$(jq -r '.width | floor' <<<"$monitor")"
monitor_height="$(jq -r '.height | floor' <<<"$monitor")"
monitor_x="$(jq -r '.x | floor' <<<"$monitor")"
monitor_y="$(jq -r '.y | floor' <<<"$monitor")"

focusing_client="$(mmsg get focusing-client 2>/dev/null || true)"
[ -n "$focusing_client" ] || exit 0
is_floating="$(jq -r '.is_floating // false' <<<"$focusing_client")"
if [ "$is_floating" != "true" ]; then
  mmsg dispatch togglefloating
  exit 0
fi

usable_x=$((monitor_x + left_inset))
usable_y=$((monitor_y + top_inset))
usable_width=$((monitor_width - left_inset - right_inset))
usable_height=$((monitor_height - top_inset - bottom_inset))

column_width=$(((usable_width - snap_gap) / 2))
row_height=$(((usable_height - snap_gap) / 2))
right_x=$((usable_x + column_width + snap_gap))
bottom_y=$((usable_y + row_height + snap_gap))
right_width=$((usable_x + usable_width - right_x))
bottom_height=$((usable_y + usable_height - bottom_y))

left_zone_outer=$monitor_x
left_zone_inner=$((monitor_x + snap_range))
right_zone_outer=$((monitor_x + monitor_width))
right_zone_inner=$((monitor_x + monitor_width - snap_range))
top_zone_outer=$monitor_y
top_zone_inner=$((monitor_y + snap_range))
bottom_zone_outer=$((monitor_y + monitor_height))
bottom_zone_inner=$((monitor_y + monitor_height - snap_range))

left=false
right=false
top=false
bottom=false

if [ "$cursor_x" -ge "$left_zone_outer" ] && [ "$cursor_x" -le "$left_zone_inner" ]; then
  left=true
fi
if [ "$cursor_x" -le "$right_zone_outer" ] && [ "$cursor_x" -ge "$right_zone_inner" ]; then
  right=true
fi
if [ "$cursor_y" -ge "$top_zone_outer" ] && [ "$cursor_y" -le "$top_zone_inner" ]; then
  top=true
fi
if [ "$cursor_y" -le "$bottom_zone_outer" ] && [ "$cursor_y" -ge "$bottom_zone_inner" ]; then
  bottom=true
fi

resize_target="none"
if [ "$left" = "true" ] && [ "$top" = "true" ]; then
  resize_target="TL"
elif [ "$right" = "true" ] && [ "$top" = "true" ]; then
  resize_target="TR"
elif [ "$left" = "true" ] && [ "$bottom" = "true" ]; then
  resize_target="BL"
elif [ "$right" = "true" ] && [ "$bottom" = "true" ]; then
  resize_target="BR"
elif [ "$left" = "true" ]; then
  resize_target="L"
elif [ "$right" = "true" ]; then
  resize_target="R"
elif [ "$top" = "true" ]; then
  resize_target="T"
elif [ "$bottom" = "true" ]; then
  resize_target="B"
fi

size_tl="$column_width,$row_height"
size_tr="$right_width,$row_height"
size_bl="$column_width,$bottom_height"
size_br="$right_width,$bottom_height"
size_vertical_left="$column_width,$usable_height"
size_vertical_right="$right_width,$usable_height"
size_top_half="$usable_width,$row_height"
size_bottom_half="$usable_width,$bottom_height"

# Temporary workaround: mango parses a leading minus as a relative move, so
# reset to the origin before a target with a negative coordinate. Remove when
# upstream accepts negative absolute coordinates.
move_window() {
  if [ "$1" -lt 0 ] || [ "$2" -lt 0 ]; then
    mmsg dispatch "movewin,0,0"
  fi
  mmsg dispatch "movewin,$1,$2"
}

case "$resize_target" in
  TL)
    move_window "$usable_x" "$usable_y"
    mmsg dispatch "resizewin,$size_tl"
    ;;
  TR)
    move_window "$right_x" "$usable_y"
    mmsg dispatch "resizewin,$size_tr"
    ;;
  BL)
    move_window "$usable_x" "$bottom_y"
    mmsg dispatch "resizewin,$size_bl"
    ;;
  BR)
    move_window "$right_x" "$bottom_y"
    mmsg dispatch "resizewin,$size_br"
    ;;
  L)
    move_window "$usable_x" "$usable_y"
    mmsg dispatch "resizewin,$size_vertical_left"
    ;;
  R)
    move_window "$right_x" "$usable_y"
    mmsg dispatch "resizewin,$size_vertical_right"
    ;;
  T)
    move_window "$usable_x" "$usable_y"
    mmsg dispatch "resizewin,$size_top_half"
    ;;
  B)
    move_window "$usable_x" "$bottom_y"
    mmsg dispatch "resizewin,$size_bottom_half"
    ;;
  none)
    mmsg dispatch togglefloating
    ;;
esac
