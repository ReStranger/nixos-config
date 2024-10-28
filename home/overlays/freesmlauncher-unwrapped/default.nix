self: super: {
  freesmlauncher = super.prismlauncher-unwrapped.overrideAttrs (oldAttrs: rec {
    pname = "freesmlauncher-unwrapped";
    src = super.fetchFromGitHub {
      owner = "FreesmTeam";
      repo = "FreesmLauncher";
      rev = "refs/tags/9.0.2";
      hash = "sha256-IBvQH6AdAM5H+XH/xvRcOV9kwRBxE+7+FVtZuW3qvik=";
    };
  });
}
