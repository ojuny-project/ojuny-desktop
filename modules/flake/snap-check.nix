{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks.ojuny-snap-negative-origin =
        pkgs.runCommand "check-ojuny-snap-negative-origin" {
          nativeBuildInputs = [ pkgs.jq ];
        } ''
          bash ${../../scripts/test-ojuny-snap.sh} ${../../lib/scripts/ojuny-snap.sh}
          touch $out
        '';
    };
}
