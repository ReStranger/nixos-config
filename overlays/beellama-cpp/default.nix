_: {
  nixpkgs.overlays = [
    (_final: prev: {
      llama-cpp = prev.llama-cpp.overrideAttrs (
        finalAttrs: old: let
          inherit (prev) lib;
          buildNumber = "40600";
        in {
          version = "0.4.6";

          src = prev.fetchFromGitHub {
            owner = "Anbeeld";
            repo = "beellama.cpp";
            tag = "v${finalAttrs.version}";
            hash = "sha256-TUh9a5fWsVLYhZwZhkn+W3gPQWE+IFE6jxs5sM/O/pI=";
          };

          npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";

          preConfigure = ''
            pushd ${old.npmRoot}
            LLAMA_BUILD_NUMBER=${buildNumber} npm run build
            popd
          '';

          cmakeFlags =
            lib.filter (f: !(lib.hasInfix "LLAMA_BUILD_NUMBER" f || lib.hasInfix "LLAMA_BUILD_COMMIT" f)) old.cmakeFlags
            ++ [
              (lib.cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
              (lib.cmakeFeature "LLAMA_BUILD_COMMIT" "e6a99939")
            ];

          disabledTests =
            old.disabledTests
            ++ [
              "test-download-tail-model"
              "test-save-load-state"
              "test-save-load-state-tail"
            ];

          nativeCheckInputs = old.nativeCheckInputs ++ [prev.git];
          preCheck =
            old.preCheck
            + ''
              export GIT_DIR="$NIX_BUILD_TOP/git"
              export GIT_WORK_TREE="$src"
              git init --quiet
              git -C "$src" add --all
              git -C "$src" -c user.name=nix -c user.email=nix@localhost commit --quiet -m "beellama.cpp ${finalAttrs.version}"
              git -C "$src" tag "v${finalAttrs.version}"
            '';

          passthru = old.passthru // {updateScript = null;};

          meta =
            old.meta
            // {
              description = "beellama.cpp: KVarN, KV cache precision tail, low-bit quants in llama.cpp";
              homepage = "https://github.com/Anbeeld/beellama.cpp";
            };
        }
      );
    })
  ];
}
