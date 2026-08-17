_: {
  nixpkgs.overlays = [
    (final: prev: let
      qt6ctPatched = prev.qt6Packages.qt6ct.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or []) ++ [./qt6ct-shenanigans.patch];

        nativeBuildInputs =
          (oldAttrs.nativeBuildInputs or [])
          ++ [
            final.kdePackages.extra-cmake-modules
          ];

        buildInputs =
          (oldAttrs.buildInputs or [])
          ++ [
            final.kdePackages.kconfig
            final.kdePackages.kcolorscheme
            final.kdePackages.kiconthemes
            final.qt6.qtdeclarative
          ];
      });
    in {
      qt6ct = qt6ctPatched;
      kdePackages =
        prev.kdePackages
        // {
          qt6ct = qt6ctPatched;
        };
      qt6Packages =
        prev.qt6Packages
        // {
          qt6ct = qt6ctPatched;
        };
    })
  ];
}
