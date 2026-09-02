{
  config,
  lib,
  ...
}: let
  cfg = config.module.services.ncro;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) port;
in {
  options.module.services.ncro = {
    enable = mkEnableOption "Enable ncro service";

    port = mkOption {
      type = port;
      default = 44444;
      description = "Local ncro listen port";
    };
  };

  config = mkIf cfg.enable {
    services.ncro = {
      enable = true;
      addUpstreamPublicKeys = true;
      settings = {
        server.listen = "127.0.0.1:${toString cfg.port}";
        cache = {
          ttl = "6h";
          negative_ttl = "3m";
          latency_alpha = 0.3;

          mass_query = {
            max_concurrent_races = 64;
            per_upstream_max_inflight = 8;
            in_memory_negative_ttl = "5s";
            upstream_cooldown = "15s";
          };
        };
        upstreams = [
          {
            url = "https://cache.nixos.org";
            priority = 10;
            public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          }
          {
            url = "https://hyprland.cachix.org";
            public_key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
            filters = [
              {
                action = "allow";
                field = "name";
                pattern = "hyprland*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "xdg-desktop-portal-hyprland*";
              }
            ];
          }
          {
            url = "https://ghostty.cachix.org";
            public_key = "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=";
            filters = [
              {
                action = "allow";
                field = "name";
                pattern = "ghostty*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "libghostty-vt*";
              }
            ];
          }
          {
            url = "https://anyrun.cachix.org";
            public_key = "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s=";
            filters = [
              {
                action = "allow";
                field = "name";
                pattern = "anyrun*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "applications*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "dictionary*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "kidex*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "nix-run*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "actions*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "randr*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "rink*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "shell*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "stdin*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "symbols*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "translate*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "websearch*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "niri-focus*";
              }
              {
                action = "allow";
                field = "name";
                pattern = "anyrun-provider*";
              }
            ];
          }
          {
            url = "https://ayugram-desktop.cachix.org";
            public_key = "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA=";
            filters = [
              {
                action = "allow";
                field = "name";
                pattern = "ayugram-desktop*";
              }
            ];
          }
          {
            url = "https://tg-owt.cachix.org";
            public_key = "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w=";
            filters = [
              {
                action = "allow";
                field = "name";
                pattern = "tg_owt*";
              }
            ];
          }
          {
            url = "https://install.determinate.systems";
            public_key = "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=";
          }
          {
            url = "https://re-cache.cachix.org";
            public_key = "re-cache.cachix.org-1:zIzN9Bp2Lwpt5qMc5XReiFsgSx6G4+wZMy9UHCDJ4X4=";
          }
          {
            url = "https://attic.xuyh0120.win/lantian";
            public_key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
          }
        ];
        fallback_cache = {
          enabled = true;
          url = "https://mirror.yandex.ru/nixos/";
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        };
        logging.timestamps = false;
      };
    };
  };
}
