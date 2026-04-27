{
  self,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.module.ghostty;
  inherit (lib) mkEnableOption mkIf mkForce;
in {
  options.module.ghostty = {
    enable = mkEnableOption "Enable ghostty module";
  };

  config = mkIf cfg.enable {
    home.activation.linkGhosttyShader = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ln -fs ${self}/home/modules/ghostty/cursor_smear.glsl ~/.config/ghostty/cursor_smear.glsl
    '';
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        font-family = mkForce "Maple Mono NF";
        background-opacity = mkForce 0.89;
        custom-shader = "cursor_smear.glsl";
      };
    };
  };
}
