{ pkgs, ... }:
pkgs.telegram-desktop.overrideAttrs (old: with pkgs;
let
  mainProgram = if stdenv.isLinux then "ayugram-desktop" else "Ayugram";
in
rec {
  pname = "ayugram-desktop";
  version = "4.16.8";

  src = fetchFromGitHub {
    owner = "AyuGram";
    repo = "AyuGramDesktop";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-HrvqENRRyRzTDUUgzAHPBwNVo5dDTUsGIFOH75RQes0=";
  };

  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r ${mainProgram}.app $out/Applications
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/${mainProgram} \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '' + lib.optionalString stdenv.isDarwin ''
    wrapQtApp $out/Applications/${mainProgram}.app/Contents/MacOS/${mainProgram}
  '';

  meta = old.meta // {
    description = "AyuGram Desktop messaging app";
    homepage = "https://t.me/ayugram1338";
    longDescription = "Desktop Telegram client with good customization and Ghost mode.";
    maintainers = [ ];
    inherit mainProgram;
  };
})
