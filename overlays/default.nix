{
  self,
  allDirs,
  ...
}:
{
  imports = allDirs "${self}/overlays";
}
