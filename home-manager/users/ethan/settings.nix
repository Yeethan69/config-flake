{ ... }:
{
  git-email = "46374629+Yeethan69@users.noreply.github.com";
  git-username = "Yeethan69";
  theme-name = "irblack";
  DE = {
    name = "niri";
    bar = "waybar";
  };
  shell = "zsh";
  terminal = "kitty";
  music = [
    "spicetify"
    "playerctl"
  ];
  media = [
    "kodi"
  ];
  editors = [
    "zed"
    "neovim"
  ];
  discord = "vesktop";
  browser = "firefox";
  VPN = "PIA";
  steam.enable = true;
  gammashift.enable = true;
  virt = {
    enable = true;
    lg.enable = true;
    winapps.enable = true;
  };
  flatpak = {
    enable = true;
    packages = [
      "org.vinegarhq.Sober"
    ];
    overrides = {
      "org.vinegarhq.Sober".Context = {
        filesystems = [
          "xdg-run/app/com.discordapp.Discord:create"
          "xdg-run/discord-ipc-0"
        ];
        devices = [
          "inputR"
        ];
      };
    };
  };
}
