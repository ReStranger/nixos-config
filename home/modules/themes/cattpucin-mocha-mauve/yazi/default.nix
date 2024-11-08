{ config
  , lib
  , ... 
}:

with lib;

let
  cfg = config.module.theme.cattpucin-mocha-mauve.yazi;
in {
  options.module.theme.cattpucin-mocha-mauve.yazi = {
    enable = mkEnableOption "Enable yazi cattpucin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    programs.yazi.theme = {
      manager = {
        cwd = { fg = "#94e2d5"; };
      };

      hovered = { fg = "#1e1e2e"; bg = "#89b4fa"; };
      preview_hovered = { underline = true; };

      find_keyword = { fg = "#f9e2af"; italic = true; };
      find_position = { fg = "#f5c2e7"; bg = "reset"; italic = true; };

      marker_copied = { fg = "#a6e3a1"; bg = "#a6e3a1"; };
      marker_cut = { fg = "#f38ba8"; bg = "#f38ba8"; };
      marker_selected = { fg = "#89b4fa"; bg = "#89b4fa"; };

      tab_active = { fg = "#1e1e2e"; bg = "#cdd6f4"; };
      tab_inactive = { fg = "#cdd6f4"; bg = "#45475a"; };
      tab_width = 1;

      count_copied = { fg = "#1e1e2e"; bg = "#a6e3a1"; };
      count_cut = { fg = "#1e1e2e"; bg = "#f38ba8"; };
      count_selected = { fg = "#1e1e2e"; bg = "#89b4fa"; };

      border_symbol = "│";
      border_style = { fg = "#7f849c"; };

      syntect_theme = "~/.config/yazi/Catppuccin-mocha.tmTheme";

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "#45475a"; bg = "#45475a"; };
      };

      mode_normal = { fg = "#1e1e2e"; bg = "#89b4fa"; bold = true; };
      mode_select = { fg = "#1e1e2e"; bg = "#a6e3a1"; bold = true; };
      mode_unset = { fg = "#1e1e2e"; bg = "#f2cdcd"; bold = true; };

      progress_label = { fg = "#ffffff"; bold = true; };
      progress_normal = { fg = "#89b4fa"; bg = "#45475a"; };
      progress_error = { fg = "#f38ba8"; bg = "#45475a"; };

      permissions_t = { fg = "#89b4fa"; };
      permissions_r = { fg = "#f9e2af"; };
      permissions_w = { fg = "#f38ba8"; };
      permissions_x = { fg = "#a6e3a1"; };
      permissions_s = { fg = "#7f849c"; };

      input = {
        border = { fg = "#89b4fa"; };
        title = {};
        value = {};
        selected = { reversed = true; };
      };

      select = {
        border = { fg = "#89b4fa"; };
        active = { fg = "#f5c2e7"; };
        inactive = {};
      };

      tasks = {
        border = { fg = "#89b4fa"; };
        title = {};
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = "#313244"; };
        cand = { fg = "#94e2d5"; };
        rest = { fg = "#9399b2"; };
        desc = { fg = "#f5c2e7"; };
        separator = "  ";
        separator_style = { fg = "#585b70"; };
      };

      help = {
        on = { fg = "#f5c2e7"; };
        exec = { fg = "#94e2d5"; };
        desc = { fg = "#9399b2"; };
        hovered = { bg = "#585b70"; bold = true; };
        footer = { fg = "#45475a"; bg = "#cdd6f4"; };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = "#94e2d5"; }
          { mime = "video/*"; fg = "#f9e2af"; }
          { mime = "audio/*"; fg = "#f9e2af"; }
          { mime = "application/zip"; fg = "#f5c2e7"; }
          { mime = "application/gzip"; fg = "#f5c2e7"; }
          { mime = "application/x-tar"; fg = "#f5c2e7"; }
          { mime = "application/x-bzip"; fg = "#f5c2e7"; }
          { mime = "application/x-bzip2"; fg = "#f5c2e7"; }
          { mime = "application/x-7z-compressed"; fg = "#f5c2e7"; }
          { mime = "application/x-rar"; fg = "#f5c2e7"; }
          { name = "*"; fg = "#cdd6f4"; }
          { name = "*/"; fg = "#89b4fa"; }
        ];
      };

      icon = {
        prepend_rules = [
          { name = ".SRCINFO"; text = "󰣇"; fg = "#89b4fa"; }
          { name = ".Xauthority"; text = ""; fg = "#fab387"; }
          { name = ".Xresources"; text = ""; fg = "#fab387"; }
          { name = ".babelrc"; text = ""; fg = "#f9e2af"; }
          { name = ".bash_profile"; text = ""; fg = "#a6e3a1"; }
          { name = ".bashrc"; text = ""; fg = "#a6e3a1"; }
          { name = ".dockerignore"; text = "󰡨"; fg = "#89b4fa"; }
          { name = ".ds_store"; text = ""; fg = "#45475a"; }
          { name = ".editorconfig"; text = ""; fg = "#f5e0dc"; }
          { name = ".env"; text = ""; fg = "#f9e2af"; }
          { name = ".eslintignore"; text = ""; fg = "#585b70"; }
          { name = ".eslintrc"; text = ""; fg = "#585b70"; }
          { name = ".gitattributes"; text = ""; fg = "#fab387"; }
          { name = ".gitconfig"; text = ""; fg = "#fab387"; }
          { name = ".gitignore"; text = ""; fg = "#fab387"; }
          { name = ".gitlab-ci.yml"; text = ""; fg = "#fab387"; }
          { name = ".gitmodules"; text = ""; fg = "#fab387"; }
          { name = ".gtkrc-2.0"; text = ""; fg = "#f5e0dc"; }
          { name = ".gvimrc"; text = ""; fg = "#a6e3a1"; }
          { name = ".justfile"; text = ""; fg = "#7f849c"; }
          { name = ".luaurc"; text = ""; fg = "#89b4fa"; }
          { name = ".mailmap"; text = "󰊢"; fg = "#45475a"; }
          { name = ".npmignore"; text = ""; fg = "#f38ba8"; }
          { name = ".npmrc"; text = ""; fg = "#f38ba8"; }
          { name = ".nvmrc"; text = ""; fg = "#a6e3a1"; }
          { name = ".prettierrc"; text = ""; fg = "#89b4fa"; }
          { name = ".settings.json"; text = ""; fg = "#6c7086"; }
          { name = ".vimrc"; text = ""; fg = "#a6e3a1"; }
          { name = ".xinitrc"; text = ""; fg = "#fab387"; }
          { name = ".xsession"; text = ""; fg = "#fab387"; }
          { name = ".zprofile"; text = ""; fg = "#a6e3a1"; }
          { name = ".zshenv"; text = ""; fg = "#a6e3a1"; }
          { name = ".zshrc"; text = ""; fg = "#a6e3a1"; }
          { name = "FreeCAD.conf"; text = ""; fg = "#f38ba8"; }
          { name = "PKGBUILD"; text = ""; fg = "#89b4fa"; }
          { name = "PrusaSlicer.ini"; text = ""; fg = "#fab387"; }
          { name = "PrusaSlicerGcodeViewer.ini"; text = ""; fg = "#fab387"; }
          { name = "QtProject.conf"; text = ""; fg = "#a6e3a1"; }
          { name = "R"; text = "󰟔"; fg = "#6c7086"; }
          { name = "_gvimrc"; text = ""; fg = "#a6e3a1"; }
          { name = "_vimrc"; text = ""; fg = "#a6e3a1"; }
          { name = "avif"; text = ""; fg = "#7f849c"; }
          { name = "brewfile"; text = ""; fg = "#313244"; }
          { name = "bspwmrc"; text = ""; fg = "#313244"; }
          { name = "build"; text = ""; fg = "#a6e3a1"; }
          { name = "build.gradle"; text = ""; fg = "#585b70"; }
          { name = "build.zig.zon"; text = ""; fg = "#fab387"; }
          { name = "cantorrc"; text = ""; fg = "#89b4fa"; }
          { name = "checkhealth"; text = "󰓙"; fg = "#89b4fa"; }
          { name = "cmakelists.txt"; text = ""; fg = "#7f849c"; }
          { name = "commit_editmsg"; text = ""; fg = "#fab387"; }
          { name = "compose.yaml"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "compose.yml"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "config"; text = ""; fg = "#7f849c"; }
          { name = "containerfile"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "copying"; text = ""; fg = "#f9e2af"; }
          { name = "copying.lesser"; text = ""; fg = "#f9e2af"; }
          { name = "docker-compose.yaml"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "docker-compose.yml"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "dockerfile"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "ext_typoscript_setup.txt"; text = ""; fg = "#fab387"; }
          { name = "favicon.ico"; text = ""; fg = "#f9e2af"; }
          { name = "fp-info-cache"; text = ""; fg = "#f5e0dc"; }
          { name = "fp-lib-table"; text = ""; fg = "#f5e0dc"; }
          { name = "gemfile$"; text = ""; fg = "#313244"; }
          { name = "gnumakefile"; text = ""; fg = "#7f849c"; }
          { name = "gradle-wrapper.properties"; text = ""; fg = "#585b70"; }
          { name = "gradle.properties"; text = ""; fg = "#585b70"; }
          { name = "gradlew"; text = ""; fg = "#585b70"; }
          { name = "groovy"; text = ""; fg = "#585b70"; }
          { name = "gruntfile.babel.js"; text = ""; fg = "#fab387"; }
          { name = "gruntfile.coffee"; text = ""; fg = "#fab387"; }
          { name = "gruntfile.js"; text = ""; fg = "#fab387"; }
          { name = "gruntfile.ts"; text = ""; fg = "#fab387"; }
          { name = "gtkrc"; text = ""; fg = "#f5e0dc"; }
          { name = "gulpfile.babel.js"; text = ""; fg = "#f38ba8"; }
          { name = "gulpfile.coffee"; text = ""; fg = "#f38ba8"; }
          { name = "gulpfile.js"; text = ""; fg = "#f38ba8"; }
          { name = "gulpfile.ts"; text = ""; fg = "#f38ba8"; }
          { name = "hyprland.conf"; text = ""; fg = "#74c7ec"; }
          { name = "i3blocks.conf"; text = ""; fg = "#f5e0dc"; }
          { name = "i3status.conf"; text = ""; fg = "#f5e0dc"; }
          { name = "justfile"; text = ""; fg = "#7f849c"; }
          { name = "kalgebrarc"; text = ""; fg = "#89b4fa"; }
          { name = "kdeglobals"; text = ""; fg = "#89b4fa"; }
          { name = "kdenlive-layoutsrc"; text = ""; fg = "#89b4fa"; }
          { name = "kdenliverc"; text = ""; fg = "#89b4fa"; }
          { name = "kritadisplayrc"; text = ""; fg = "#cba6f7"; }
          { name = "kritarc"; text = ""; fg = "#cba6f7"; }
          { name = "license"; text = ""; fg = "#f9e2af"; }
          { name = "lxde-rc.xml"; text = ""; fg = "#9399b2"; }
          { name = "lxqt.conf"; text = ""; fg = "#89b4fa"; }
          { name = "makefile"; text = ""; fg = "#7f849c"; }
          { name = "mix.lock"; text = ""; fg = "#7f849c"; }
          { name = "mpv.conf"; text = ""; fg = "#1e1e2e"; }
          { name = "node_modules"; text = ""; fg = "#f38ba8"; }
          { name = "package-lock.json"; text = ""; fg = "#313244"; }
          { name = "package.json"; text = ""; fg = "#f38ba8"; }
          { name = "platformio.ini"; text = ""; fg = "#fab387"; }
          { name = "pom.xml"; text = ""; fg = "#313244"; }
          { name = "procfile"; text = ""; fg = "#7f849c"; }
          { name = "py.typed"; text = ""; fg = "#f9e2af"; }
          { name = "r"; text = "󰟔"; fg = "#6c7086"; }
          { name = "rakefile"; text = ""; fg = "#313244"; }
          { name = "settings.gradle"; text = ""; fg = "#585b70"; }
          { name = "svelte.config.js"; text = ""; fg = "#fab387"; }
          { name = "sxhkdrc"; text = ""; fg = "#313244"; }
          { name = "sym-lib-table"; text = ""; fg = "#f5e0dc"; }
          { name = "tailwind.config.js"; text = "󱏿"; fg = "#74c7ec"; }
          { name = "tailwind.config.mjs"; text = "󱏿"; fg = "#74c7ec"; }
          { name = "tailwind.config.ts"; text = "󱏿"; fg = "#74c7ec"; }
          { name = "tmux.conf"; text = ""; fg = "#a6e3a1"; }
          { name = "tmux.conf.local"; text = ""; fg = "#a6e3a1"; }
          { name = "tsconfig.json"; text = ""; fg = "#74c7ec"; }
          { name = "unlicense"; text = ""; fg = "#f9e2af"; }
          { name = "vagrantfile$"; text = ""; fg = "#6c7086"; }
          { name = "vlcrc"; text = "󰕼"; fg = "#fab387"; }
          { name = "webpack"; text = "󰜫"; fg = "#74c7ec"; }
          { name = "weston.ini"; text = ""; fg = "#f9e2af"; }
          { name = "workspace"; text = ""; fg = "#a6e3a1"; }
          { name = "xmobarrc"; text = ""; fg = "#f38ba8"; }
          { name = "xmobarrc.hs"; text = ""; fg = "#f38ba8"; }
          { name = "xmonad.hs"; text = ""; fg = "#f38ba8"; }
          { name = "xorg.conf"; text = ""; fg = "#fab387"; }
          { name = "xsettingsd.conf"; text = ""; fg = "#fab387"; }
          { name = "*.3gp"; text = ""; fg = "#fab387"; }
          { name = "*.3mf"; text = "󰆧"; fg = "#7f849c"; }
          { name = "*.7z"; text = ""; fg = "#fab387"; }
          { name = "*.Dockerfile"; text = "󰡨"; fg = "#89b4fa"; }
          { name = "*.a"; text = ""; fg = "#f5e0dc"; }
          { name = "*.aac"; text = ""; fg = "#74c7ec"; }
          { name = "*.ai"; text = ""; fg = "#f9e2af"; }
          { name = "*.aif"; text = ""; fg = "#74c7ec"; }
          { name = "*.aiff"; text = ""; fg = "#74c7ec"; }
          { name = "*.android"; text = ""; fg = "#a6e3a1"; }
          { name = "*.ape"; text = ""; fg = "#74c7ec"; }
          { name = "*.apk"; text = ""; fg = "#a6e3a1"; }
          { name = "*.app"; text = ""; fg = "#45475a"; }
          { name = "*.applescript"; text = ""; fg = "#7f849c"; }
          { name = "*.asc"; text = "󰦝"; fg = "#6c7086"; }
        ];
      };
    };
  };
}
