{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nemo-with-extensions
    nemo-fileroller
  ];
  dconf = {
    settings."org/nemo/window-state" = {
      start-with-menu-bar = false;
    };
    settings."org/cinnamon/desktop/default-applications/terminal" = {
      exec = "alacritty -e";
      exec-arg = "";
    };
  };
}
