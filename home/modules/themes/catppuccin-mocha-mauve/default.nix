{ self
, allDirs
, ...
}:

{
  imports = allDirs "${self}/home/modules/themes/catppuccin-mocha-mauve";
}

