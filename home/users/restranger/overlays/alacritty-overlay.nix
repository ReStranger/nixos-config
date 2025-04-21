_self: super: {
  alacritty-smooth-cursor = super.alacritty.overrideAttrs (_oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "GregTheMadMonk";
      repo = "alacritty-smooth-cursor";
      rev = "ec2f519681cdde7f6aede70a5481517252e515c5";
      hash = "";
    };
    cargoHash = "";
  });
}
