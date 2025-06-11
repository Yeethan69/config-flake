{
  pkgs,
  vars,
  lib,
  ...
}:
let
  moduleFiles = lib.filesystem.listFilesRecursive ./modules;
  modules = lib.filter (f: lib.strings.hasSuffix ".nix" (toString f)) moduleFiles;
in
{
  imports = modules;
  # Styling
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${vars.theme-name}.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };
  };

  prism = {
    enable = true;
    # Wallpapers from https://ultrawidewallpapers.net
    wallpapers = ./wallpapers;
    outPath = "wallpapers";
    colorscheme = vars.theme-name;
  };

  # Git
  programs.git = {
    enable = true;
    userName = vars.git-username;
    userEmail = vars.git-email;
  };

  # General
  programs.fastfetch.enable = true;
  programs.btop.enable = true;
}
