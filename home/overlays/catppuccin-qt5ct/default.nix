_: prev: {
  catppuccin-qt5ct = prev.catppuccin-qt5ct.overrideAttrs {
    # version = "2023-12-03";
    src = prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "qt5ct";
      rev = "0442cc931390c226d143e3a6d6e77f819c68502a";
      hash = "sha256-hXyPuI225WdMuVSeX1AwrylUzNt0VA33h8C7MoSJ+8A=";
    };
  };
}
