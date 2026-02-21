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
    # FIXME: Do not hardcode this path
    home.activation.linkZenThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -fs ~/.config/nixos/home/modules/zen-browser/zen-themes.json ~/.config/zen/default/zen-themes.json
    '';
    programs.zen-browser = {
      enable = true;
      suppressXdgMigrationWarning = true;
      policies =
        let
          mkLockedAttrs = builtins.mapAttrs (
            _: value: {
              Value = value;
              Status = "locked";
            }
          );
          mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

          mkExtensionEntry =
            {
              id,
              pinned ? false,
            }:
            let
              base = {
                install_url = mkPluginUrl id;
                installation_mode = "force_installed";
              };
            in
            if pinned then base // { default_area = "navbar"; } else base;

          mkExtensionSettings = builtins.mapAttrs (
            _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
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
          SanitizeOnShutdown = {
            FormData = true;
            Cache = true;
          };
          ExtensionSettings = mkExtensionSettings {
            "uBlock0@raymondhill.net" = mkExtensionEntry {
              id = "ublock-origin";
              pinned = true;
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
              id = "bitwarden-password-manager";
              pinned = true;
            };
            "authenticator@mymindstorm" = "auth-helper";
            "firefox@betterttv.net" = "betterttv";
            "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}" = "catppuccin-web-file-icons";
            "addon@darkreader.org" = "darkreader";
            "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
            "2.0@disconnect.me" = "disconnect";
            "jid1-ZAdIEUB7XOzOJw@jetpack" = "duckduckgo-for-firefox";
            "idcac-pub@guus.ninja" = "istilldontcareaboutcookies";
            "multithreaded-download-manager@qw.linux-2g64.local" = "multithreaded-download-manager";
            "{73a6fe31-595d-460b-a920-fcc0f8843232}" = "noscript";
            "jid1-MnnxcxisBPnSXQ@jetpack" = "privacy-badger17";
            "{ddc62400-f22d-4dd3-8b4a-05837de53c2e}" = "read-aloud";
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
            "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = "search_by_image";
            "sponsorBlocker@ajay.app" = "sponsorblock";
            "syncshare@naloaty.me" = "syncshare";
            "firefox@tampermonkey.net" = "tampermonkey";
            "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = "traduzir-paginas-web";
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
            "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = "view-page-archive";
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
