{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.discord;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.discord = {
    enable = mkEnableOption "Enable discord with vencord patches";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];

    xdg.configFile."Vencord/settings/settings.json".text =
      let
        plugins = {
          CommandsAPI = {
            enabled = true;
          };
          DynamicImageModalAPI = {
            enabled = true;
          };
          MemberListDecoratorsAPI = {
            enabled = true;
          };
          MessageAccessoriesAPI = {
            enabled = true;
          };
          MessageDecorationsAPI = {
            enabled = true;
          };
          MessageEventsAPI = {
            enabled = true;
          };
          ServerListAPI = {
            enabled = true;
          };
          UserSettingsAPI = {
            enabled = true;
          };
          AlwaysAnimate = {
            enabled = true;
          };
          BetterFolders = {
            enabled = true;
          };
          BetterGifAltText = {
            enabled = true;
          };
          BetterGifPicker = {
            enabled = true;
          };
          BetterNotesBox = {
            enabled = true;
          };
          BetterRoleContext = {
            enabled = true;
          };
          BetterRoleDot = {
            enabled = true;
          };
          BetterSettings = {
            enabled = true;
          };
          BetterUploadButton = {
            enabled = true;
          };
          BiggerStreamPreview = {
            enabled = true;
          };
          CallTimer = {
            enabled = true;
          };
          CrashHandler = {
            enabled = true;
          };
          Decor = {
            enabled = true;
          };
          ExpressionCloner = {
            enabled = true;
          };
          FakeNitro = {
            enabled = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickers = true;
            transformCompoundSentence = false;
          };
          FakeProfileThemes = {
            enabled = true;
          };
          FavoriteEmojiFirst = {
            enabled = true;
          };
          FavoriteGifSearch = {
            enabled = true;
          };
          FixCodeblockGap = {
            enabled = true;
          };
          FixImagesQuality = {
            enabled = true;
          };
          FixSpotifyEmbeds = {
            enabled = true;
          };
          FixYoutubeEmbeds = {
            enabled = true;
          };
          FriendInvites = {
            enabled = true;
          };
          GameActivityToggle = {
            enabled = true;
          };
          ImageFilename = {
            enabled = true;
          };
          ImageLink = {
            enabled = true;
          };
          ImageZoom = {
            enabled = true;
            saveZoomValues = true;
            invertScroll = true;
            nearestNeighbour = false;
            square = false;
            zoom = 2;
            size = 100;
            zoomSpeed = 0.5;
          };
          MemberCount = {
            enabled = true;
          };
          PermissionsViewer = {
            enabled = true;
          };
          petpet = {
            enabled = true;
          };
          PictureInPicture = {
            enabled = true;
          };
          PlatformIndicators = {
            enabled = true;
          };
          ReadAllNotificationsButton = {
            enabled = true;
          };
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineName = "https://duckduckgo.com/";
            customEngineURL = "https://duckduckgo.com/search?q=";
          };
          ServerInfo = {
            enabled = true;
          };
          ShowHiddenChannels = {
            enabled = true;
          };
          ShowHiddenThings = {
            enabled = true;
          };
          ShowMeYourName = {
            enabled = true;
          };
          SpotifyControls = {
            enabled = true;
            hoverControls = false;
            useSpotifyUris = false;
            previousButtonRestartsTrack = true;
          };
          SpotifyCrack = {
            enabled = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = false;
          };
          SpotifyShareCommands = {
            enabled = true;
          };
          UnlockedAvatarZoom = {
            enabled = true;
            zoomMultiplier = 4;
          };
          UserVoiceShow = {
            enabled = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };
          VoiceDownload = {
            enabled = true;
          };
          VoiceMessages = {
            enabled = true;
          };
          VolumeBooster = {
            enabled = true;
            multiplier = 2;
          };
          WhoReacted = {
            enabled = true;
          };
          YoutubeAdblock = {
            enabled = true;
          };
          BadgeAPI = {
            enabled = true;
          };
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          SupportHelper = {
            enabled = true;
          };
        };

        vencordSettings = {
          plugins = plugins;
        };
      in
      builtins.toJSON vencordSettings;
  };
}
