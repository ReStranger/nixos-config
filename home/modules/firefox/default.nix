{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.module.firefox;
in
{
  options.module.firefox = {
    enable = mkEnableOption "Enable firefox module";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      languagePacks = [ "ru" ];
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          # Scrolling
          "general.smoothscroll.lines.durationMaxms" = 125;
          "general.smoothscroll.lines.durationMinms" = 125;
          "general.smoothscroll.mousewheel.durationMaxms" = 200;
          "general.smoothscroll.mousewheel.durationMinms" = 100;
          "general.smoothscroll.msdphysics.enabled" = true;
          "general.smoothscroll.ether.durationMaxms" = 125;
          "general.smoothscroll.other.durationminms" = 125;
          "general.smoothscroll.pages.durationMaxms" = 125;
          "general.smoothscroll.pages.durationminms" = 125;
          "mousewheel.min_line_scroll_amount" = 30;
          "mousewheel.system_scroll_override_on_root_content.enabled" = true;
          "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
          "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
          "toolkit.scrollbox.horizontalscrolldistance" = 6;
          "toolkit.scrollbox.verticalscrolldistance" = 2;

          # Perf
          "gfx.webrender.all" = true;
          "extensions.pocket.enabled" = false;
          "media.hardware-video-decoding.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;

          # Privacy
          "datareporting.healthreport.uploadEnabled" = false;
          "dom.security.https_only_mode_ever_enabled" = true;
          "dom.security.https_only_mode_ever_enabled_pbm" = true;
          "dom.security.https_only_mode" = true;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "network.captive-portal-service.enabled " = false;
          "privacy.trackingprotection.annotate_channels" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "media.peerconnection.ice.default_address_only" = true;
          "signon.autofillForms" = false;
          "signon.firefoxRelay.feature" = "disabled";
          "signon.generation.enabled" = false;
          "signon.rememberSignons" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.rejected" = true;
          "privacy.donottrackheader.enabled" = true;
          "network.dns.echconfig.enabled" = true;
          "network.dns.http3_echconfig.enabled" = true;
          # UI
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "always-show";
        };
      };
    };
  };
}
