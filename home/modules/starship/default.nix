{
  config,
  lib,
  ...
}: let
  cfg = config.module.starship;
  inherit (lib) mkEnableOption mkIf concatStrings;
in {
  options.module.starship = {
    enable = mkEnableOption "Enable starship module";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = concatStrings [
          "$hostname"
          "$nix_shell"
          "$os"
          "$directory"
          "$battery"
          "$container"
          "$git_branch $git_state"
          "$python"
          "$nodejs"
          "$bun"
          "$deno"
          "$lua"
          "$rust"
          "$java"
          "$c"
          "$cpp"
          "$cmake"
          "$golang"
          "$cmd_duration"
          "$jobs"
          "$status"
          "$line_break"
          "[❯](bold purple)"
          "\${custom.space}"
        ];

        palette = "base16";

        custom.space = {
          when = "! test $env";
          format = " ";
        };

        continuation_prompt = "∙  ┆ ";

        line_break.disabled = false;
        hostname = {
          ssh_only = true;
          format = "[](fg:base04)[$ssh_symbol $hostname](bg:base04 fg:white)[](fg:base04) ";
          ssh_symbol = "";
        };

        battery = {
          format = " [](fg:bright-black)[$path](bg:bright-black fg:white)[](fg:bright-black)";
          disabled = false;
        };

        status = {
          symbol = "✗";
          not_found_symbol = "󰍉 Not Found";
          not_executable_symbol = " Can't Execute";
          sigint_symbol = "󰂭 ";
          signal_symbol = "󱑽 ";
          success_symbol = "";
          format = "[$symbol](fg:red)";
          map_symbol = true;
          disabled = false;
        };

        cmd_duration = {
          min_time = 1000;
          format = "[$duration ](fg:yellow)";
        };

        nix_shell = {
          disabled = false;
          format = "[](fg:white)[ ](bg:white fg:black)[](fg:white) ";
        };

        container = {
          symbol = " 󰏖";
          format = "[$symbol ](yellow dimmed)";
        };

        directory = {
          format = " [](fg:bright-black)[$path](bg:bright-black fg:white)[](fg:bright-black) [$read_only]($read_only_style)";
          read_only = " ";
          read_only_style = "fg:yellow";
          truncate_to_repo = true;
          truncation_length = 4;
          truncation_symbol = "";
        };

        git_branch = {
          symbol = "";
          style = "";
          format = "[ $symbol $branch](fg:purple)(:$remote_branch)";
        };
        git_state = {
          format = "[](fg:yellow)[$state( $progress_current/$progress_total)](bg:yellow fg:black)[](fg:yellow) ";
        };

        os = {
          disabled = false;
          format = "$symbol";
          symbols = {
            Arch = "[ ](fg:bright-blue)";
            Alpine = "[ ](fg:bright-blue)";
            Debian = "[ ](fg:red)";
            EndeavourOS = "[ ](fg:purple)";
            Fedora = "[ ](fg:blue)";
            NixOS = "[ ](fg:blue)";
            openSUSE = "[ ](fg:green)";
            SUSE = "[ ](fg:green)";
            Ubuntu = "[ ](fg:bright-purple)";
            Macos = "[ ](fg:white)";
          };
        };

        python = {
          symbol = "";
          format = "[$symbol ](yellow)";
        };

        nodejs = {
          symbol = "󰛦";
          format = "[$symbol ](bright-blue)";
        };

        bun = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        deno = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        lua = {
          symbol = "󰢱";
          format = "[$symbol ](blue)";
        };

        rust = {
          symbol = "";
          format = "[$symbol ](red)";
        };

        java = {
          symbol = "";
          format = "[$symbol ](red)";
        };

        c = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        cpp = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        cmake = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        golang = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        dart = {
          symbol = "";
          format = "[$symbol ](blue)";
        };

        elixir = {
          symbol = "";
          format = "[$symbol ](purple)";
        };
      };
    };
  };
}
