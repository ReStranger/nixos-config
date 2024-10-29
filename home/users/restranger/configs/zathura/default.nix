{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
    };
    mappings = {
      "<C-l> feedkeys" = ":blist <Tab>";
      "<C-m> feedkeys" = ":bmark ";
      "<C-u> feedkeys" = ":bdelete ";
      i = "recolor";
    };
  };
}
