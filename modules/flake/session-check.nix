{ ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      sessionFile = pkgs.writeText "ojuny-session-check.json" ''
        {"configVersion":7,"wallpaperPath":"/nix/store/default.png"}
      '';
      linker = import ../../lib/mk-linker.nix {
        inherit lib pkgs;
        configLinks = { };
        duxSessionFile = sessionFile;
      };
    in
    {
      checks.session-seed = pkgs.runCommand "check-ojuny-session-seed" { } ''
        export HOME="$TMPDIR/home"
        export XDG_STATE_HOME="$TMPDIR/state"
        mkdir -p "$HOME"
        ${linker}/bin/ojuny-config --seed
        grep -q 'default.png' "$XDG_STATE_HOME/dms/session.json"
        printf '{"wallpaperPath":"/nix/store/stale.png"}\n' > "$XDG_STATE_HOME/dms/session.json"
        ${linker}/bin/ojuny-config --seed
        grep -q 'default.png' "$XDG_STATE_HOME/dms/session.json"
        if grep -q 'stale.png' "$XDG_STATE_HOME/dms/session.json"; then
          echo "the stale session was not replaced" >&2
          exit 1
        fi
        touch $out
      '';
    };
}
