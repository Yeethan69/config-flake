{ pkgs, ... }:
{
  git-email = "46374629+Yeethan69@users.noreply.github.com";
  git-username = "Yeethan69";
  base16-theme = "${pkgs.base16-schemes}/share/themes/black-metal.yaml";
  theme-name = "black-metal-base16";
  DE = {
    name = "niri";
    waybar.enable = true;
  };
  shell = "zsh";
  terminal = "kitty";
  music = [
    "spicetify"
    "playerctl"
  ];
  editors = [
    "zed"
  ];
}
