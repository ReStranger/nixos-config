_: {
  nixpkgs.overlays = [
    (_final: prev: let
      inherit (prev) lib;
      beeVersion = "0.4.6";
      beeSrc = prev.fetchFromGitHub {
        owner = "Anbeeld";
        repo = "beellama.cpp";
        tag = "v${beeVersion}";
        hash = "sha256-TUh9a5fWsVLYhZwZhkn+W3gPQWE+IFE6jxs5sM/O/pI=";
      };
      beeNpmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";

      overrideBee = pkg:
        pkg.overrideAttrs (old: let
          # Must stay numeric: upstream CMake expects an int here.
          buildNumber = "40600";
          buildCommit = "v${beeVersion}";
        in {
          version = beeVersion;
          src = beeSrc;
          npmDepsHash = beeNpmDepsHash;

          preConfigure = ''
            pushd ${old.npmRoot or "tools/ui"}
            LLAMA_BUILD_NUMBER=${buildNumber} npm run build
            popd
          '';

          cmakeFlags =
            lib.filter (
              flag:
                !(lib.hasInfix "LLAMA_BUILD_NUMBER=" flag
                  || lib.hasInfix "LLAMA_BUILD_COMMIT=" flag)
            )
            old.cmakeFlags
            ++ [
              (lib.cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
              (lib.cmakeFeature "LLAMA_BUILD_COMMIT" buildCommit)
            ];

          meta =
            old.meta
            // {
              homepage = "https://github.com/Anbeeld/beellama.cpp";
            };
        });
    in {
      llama-cpp = overrideBee prev.llama-cpp;
      llama-cpp-cuda = overrideBee prev.llama-cpp-cuda;
      llama-cpp-rocm = overrideBee prev.llama-cpp-rocm;
      llama-cpp-vulkan = overrideBee prev.llama-cpp-vulkan;
    })
  ];
}
