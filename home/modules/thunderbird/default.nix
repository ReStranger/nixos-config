{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.thunderbird;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.thunderbird = {
    enable = mkEnableOption "Enable thunderbird module";
  };

  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        # name = "default";
        isDefault = true;
        settings = {
          "privacy.donottrackheader.enabled" = true;
        };
        search = {
          force = true;
          default = "ddg";
          privateDefault = "google";
          engines =
            let
              nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            in
            {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = [ "@nixp" ];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = [ "@nixo" ];
              };
              "Home Manager Options" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com/";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "release";
                        value = "master"; # unstable
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = [ "@hmo" ];
              };
            };
        };
      };
    };
  };
}
