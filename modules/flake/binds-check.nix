{ ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      bindsLib = import ../../lib/to-binds.nix lib;
      cheatsheet = bindsLib.toCheatsheet [
        {
          normal = {
            a-device = {
              modifier = [ "SUPER" ];
              keys = [ "1" ];
              dispatcher = "spawn";
              args = [ ];
              description = "Device bind";
              group = "Test";
              displayKey = "G1";
            };
            b-chord = {
              modifier = [ "SUPER" ];
              keys = [ "r" ];
              dispatcher = "spawn";
              args = [ ];
              description = "Chord bind";
              group = "Test";
            };
          };
        }
      ];
      entries = cheatsheet.binds.Test;
    in
    {
      checks.binds-display-key =
        assert (builtins.elemAt entries 0).key == "G1";
        assert (builtins.elemAt entries 1).key == "SUPER+r";
        pkgs.runCommand "check-ojuny-binds-display-key" { } ''
          touch $out
        '';
    };
}
