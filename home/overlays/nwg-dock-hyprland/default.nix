_: prev: {
  nwg-dock-hyprland = prev.nwg-dock-hyprland.overrideAttrs rec {
    pname = "nwg-dock-hyprland";
    version = "0.4.2";
    src = prev.fetchFromGitHub {
      owner = "nwg-piotr";
      repo = "nwg-dock-hyprland";
      tag = "v${version}";
      hash = "sha256-IKdXH2UK2CBZTHY8c9eN6JSbqsF4OpIHYH14XEKyrM0=";
    };
    vendorHash = "sha256-ZUk3Pust9+Ei7s4ArNtTqBIWhxlzFjXcmDePBUYCaEU=";
  };
}
