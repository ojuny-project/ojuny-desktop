#!/usr/bin/env bash
set -euo pipefail

script="${1:-$(cd "$(dirname "$0")/.." && pwd)/lib/scripts/ojuny-snap.sh}"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

mkdir -p "$work_dir/bin"
{
  printf '#!%s\n' "$(command -v bash)"
  cat <<'STUB'
set -euo pipefail

state_file="${SNAP_STATE:?}"
log_file="${SNAP_LOG:?}"
read -r state_x state_y state_w state_h <"$state_file"

parse_value() {
  case "$2" in
    -*) printf '%s' "$(($1 - ${2#-}))" ;;
    +*) printf '%s' "$(($1 + ${2#+}))" ;;
    *) printf '%s' "$2" ;;
  esac
}

if [ "$1" = "dispatch" ]; then
  printf '%s\n' "$2" >>"$log_file"
  payload="${2//,/ }"
  # shellcheck disable=SC2086
  set -- $payload
  case "$1" in
    movewin)
      state_x="$(parse_value "$state_x" "$2")"
      state_y="$(parse_value "$state_y" "$3")"
      ;;
    resizewin)
      state_w="$(parse_value "$state_w" "$2")"
      state_h="$(parse_value "$state_h" "$3")"
      ;;
  esac
  printf '%s %s %s %s\n' "$state_x" "$state_y" "$state_w" "$state_h" >"$state_file"
  exit 0
fi

case "$1 $2" in
  "get cursorpos")
    printf '{"x":%s,"y":%s,"monitor":"DP-1"}\n' "$SNAP_CURSOR_X" "$SNAP_CURSOR_Y"
    ;;
  "get monitor"*)
    printf '{"x":%s,"y":%s,"width":1920,"height":1080}\n' "$SNAP_MONITOR_X" "$SNAP_MONITOR_Y"
    ;;
  "get focusing-client")
    printf '{"is_floating":true}\n'
    ;;
esac
STUB
} >"$work_dir/bin/mmsg"
chmod +x "$work_dir/bin/mmsg"

run_case() {
  local name="$1"
  local monitor_x="$2"
  local monitor_y="$3"
  local cursor_x="$4"
  local cursor_y="$5"
  local client_x="$6"
  local client_y="$7"
  local expected_state="$8"
  local expected_log
  expected_log="$(cat)"

  export SNAP_STATE="$work_dir/$name.state"
  export SNAP_LOG="$work_dir/$name.log"
  export SNAP_MONITOR_X="$monitor_x"
  export SNAP_MONITOR_Y="$monitor_y"
  export SNAP_CURSOR_X="$cursor_x"
  export SNAP_CURSOR_Y="$cursor_y"

  printf '%s %s 800 600\n' "$client_x" "$client_y" >"$SNAP_STATE"
  : >"$SNAP_LOG"
  printf '%s\n' "$expected_log" >"$work_dir/$name.expected"

  OJUNY_SNAP_CONFIG="$work_dir/missing.conf" PATH="$work_dir/bin:$PATH" bash "$script"

  diff -u "$work_dir/$name.expected" "$SNAP_LOG" >&2 || fail "$name: dispatch log"
  test "$(cat "$SNAP_STATE")" = "$expected_state" || fail "$name: final geometry"
}

run_case negative_both -1920 -1080 -1900 -1060 -1000 -500 "-1917 -1035 955 513" <<'LOG'
movewin,0,0
movewin,-1917,-1035
resizewin,955,513
LOG

run_case negative_x -1920 0 -1900 100 -1000 100 "-1917 45 955 513" <<'LOG'
movewin,0,0
movewin,-1917,45
resizewin,955,513
LOG

run_case negative_y 0 -1920 100 -1900 100 -1000 "3 -1875 955 513" <<'LOG'
movewin,0,0
movewin,3,-1875
resizewin,955,513
LOG

run_case positive_both 0 0 100 100 500 500 "3 45 955 513" <<'LOG'
movewin,3,45
resizewin,955,513
LOG

printf 'ok\n'
