self: super: {
  alacritty-smooth-cursor = super.alacritty.overrideAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "GregTheMadMonk";
      repo = "alacritty-smooth-cursor";
      rev = "303a92ea57a074bb50ff016c8da7a0aeae897b1a";
      hash = "sha256-aoel3P7MnO39ekBJPaTnaizJkbUaOS7sy1ktwow9JN8=";
    };
    cargoHash = "sha256-f95bYfqJCFJjiZdkKkHw3UORgrit6AQvoktLcfSZYAw=";
  });
}
