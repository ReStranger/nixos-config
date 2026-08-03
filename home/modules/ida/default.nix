{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {

  options.module.ida = {
    enable = mkEnableOption "Enable ida module";
  };

  config = mkIf config.module.ida.enable {
    home.packages = [
      (pkgs.ida-pro.override {
        hexPatches = [
          {
            filename = "libida.so";
            from = "57140525650BCF6E";
            to = "57141525650BCF6E";
            # assertCount = 1;
          }
          {
            filename = "libida32.so";
            from = "57140525650BCF6E";
            to = "57141525650BCF6E";
            # assertCount = 1;
          }
          {
            filename = "libida.dylib";
            from = "57140525650BCF6E";
            to = "57141525650BCF6E";
            # assertCount = 1;
          }
          {
            filename = "libida32.dylib";
            from = "57140525650BCF6E";
            to = "57141525650BCF6E";
            # assertCount = 1;
          }
        ];
      })
    ];
  };
}
