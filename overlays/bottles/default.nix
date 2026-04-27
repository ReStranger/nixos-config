_: {
  nixpkgs.overlays = [
    (final: prev: {
      bottles = prev.bottles.override {
        removeWarningPopup = true;
        buildFHSEnv =
          args:
          prev.buildFHSEnv (
            args
            // {
              multiPkgs =
                envPkgs:
                let
                  originalPkgs = args.multiPkgs envPkgs;

                  customLdap = envPkgs.openldap.overrideAttrs (_old: {
                    doCheck = false;
                  });
                in
                builtins.filter (p: (p.pname or (final.lib.getName p)) != "openldap") originalPkgs
                ++ [ customLdap ];
            }
          );
      };
    })
  ];
}
