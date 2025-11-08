{
  config,
  lib,
  pkgs,
  isLinux,
  hyprlandEnable,
  ...
}:

let
  cfg = config.module.zen-browser;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.zen-browser = {
    enable = mkEnableOption "Enable zen-browser module";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies =
        let
          mkLockedAttrs = builtins.mapAttrs (
            _: value: {
              Value = value;
              Status = "locked";
            }
          );
        in
        {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          Preferences = mkLockedAttrs {
            "intl.locale.requested" = "ru";

            # Security
            "dom.security.https_only_mode_ever_enabled" = true;
            "dom.security.https_only_mode_ever_enabled_pbm" = true;
            "dom.security.https_only_mode" = true;
            "media.peerconnection.ice.default_address_only" = true;
            "network.captive-portal-service.enabled " = false;
            "network.cookie.cookieBehavior" = 5;
            "network.dns.echconfig.enabled" = true;
            "network.dns.http3_echconfig.enabled" = true;
            "privacy.firstparty.isolate" = true;
            "privacy.resistFingerprinting" = true;

            # Perf
            "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
            "browser.topsites.contile.enabled" = false;
            "gfx.webrender.all" = true;
            "media.hardware-video-decoding.enabled" = true;
            "media.hardware-video-decoding.force-enabled" = true;

            # UI
            "browser.aboutConfig.showWarning" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.translations.automaticallyPopup" = false;
          };
        };
      profiles.default = {
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.experimental-no-window-controls" = hyprlandEnable;
          "zen.view.gray-out-inactive-windows" = isLinux;
          "zen.welcome-screen.seen" = true;
          "zen.widget.linux.transparency" = isLinux;
          "browser.tabs.allow_transparent_browser" = true;
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
