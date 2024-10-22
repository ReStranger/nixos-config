{ lib
  , config
  , ...
}:
with lib;
let
  cfg = config.module.locale;
in
{
  options.module.locale = {
    enable = mkEnableOption "Set system locale";
    locale = mkOption {
      type = types.str;
      default = "ru_RU.UTF-8";
      description = ''
        Set system locale
      '';
    };
  };
  config = mkIf cfg.enable {
    i18n.defaultLocale = "${cfg.locale}";
    i18n.extraLocaleSettings = {
      LANG = "${cfg.locale}";
      LC_ADDRESS = "${cfg.locale}";
      LC_IDENTIFICATION = "${cfg.locale}";
      LC_MEASUREMENT = "${cfg.locale}";
      LC_MONETARY = "${cfg.locale}";
      LC_NAME = "${cfg.locale}";
      LC_NUMERIC = "${cfg.locale}";
      LC_PAPER = "${cfg.locale}";
      LC_TELEPHONE = "${cfg.locale}";
      LC_TIME = "${cfg.locale}";
    };
  };
}
