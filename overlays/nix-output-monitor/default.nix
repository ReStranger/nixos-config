_: {
  nixpkgs.overlays = [
    (
      _final: prev: {
        nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              ./0001-json-accept-unknown-activity-types.patch
            ];
        });
      }
    )
  ];
}
