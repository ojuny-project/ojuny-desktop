#!/usr/bin/env bash
set -euo pipefail

snap_range="${OJUNY_SNAP_RANGE:-150}"
left_inset="${OJUNY_SNAP_LEFT_INSET:-3}"
right_inset="${OJUNY_SNAP_RIGHT_INSET:-3}"
top_inset="${OJUNY_SNAP_TOP_INSET:-45}"
bottom_inset="${OJUNY_SNAP_BOTTOM_INSET:-5}"

horizontal_inset=$((left_inset + right_inset))
vertical_inset=$((top_inset + bottom_inset))

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

top_left="$((left_zone_outer + left_inset)),$((top_zone_outer + top_inset))"
top_right="$((monitor_width / 2 + left_zone_outer)),$((top_zone_outer + top_inset))"
bottom_left="$((left_zone_outer + left_inset)),$((monitor_height / 2 + top_zone_outer + top_inset / 2))"
bottom_right="$((monitor_width / 2 + left_zone_outer)),$((monitor_height / 2 + top_zone_outer + top_inset / 2))"
size_quarter="$((monitor_width / 2 - horizontal_inset)),$((monitor_height / 2 - vertical_inset / 2))"
size_vertical_half="$((monitor_width / 2 - horizontal_inset)),$((monitor_height - vertical_inset))"
size_top_half="$((monitor_width - horizontal_inset)),$((monitor_height / 2 - top_inset))"
size_horizontal_half="$((monitor_width - horizontal_inset)),$((monitor_height / 2 - bottom_inset))"

case "$resize_target" in
  TL)
    mmsg dispatch "movewin,$top_left"
    mmsg dispatch "resizewin,$size_quarter"
    ;;
  TR)
    mmsg dispatch "movewin,$top_right"
    mmsg dispatch "resizewin,$size_quarter"
    ;;
  BL)
    mmsg dispatch "movewin,$bottom_left"
    mmsg dispatch "resizewin,$size_quarter"
    ;;
  BR)
    mmsg dispatch "movewin,$bottom_right"
    mmsg dispatch "resizewin,$size_quarter"
    ;;
  L)
    mmsg dispatch "movewin,$top_left"
    mmsg dispatch "resizewin,$size_vertical_half"
    ;;
  R)
    mmsg dispatch "movewin,$top_right"
    mmsg dispatch "resizewin,$size_vertical_half"
    ;;
  T)
    mmsg dispatch "movewin,$top_left"
    mmsg dispatch "resizewin,$size_top_half"
    ;;
  B)
    mmsg dispatch "movewin,$bottom_left"
    mmsg dispatch "resizewin,$size_horizontal_half"
    ;;
  none)
    mmsg dispatch togglefloating
    ;;
esac
