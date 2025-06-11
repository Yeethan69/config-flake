{ pkgs, ... }:
{

  # mostly from https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/x11/desktop-managers/gnome.nix

  # for gsettings (gnome settings)
  programs.dconf.enable = true;
  
  # for high priority (real-time)
  security.rtkit.enable = true;
  
  services.accounts-daemon.enable = true;
  
  # admin:// trash:// etc
  services.gvfs.enable = true;

  xdg.icons.enable = true;
  
  # auto-mounts (usb)
  services.udisks2.enable = true;

  # local network discovery
  services.avahi.enable = true;

  # location for night light, weather etc
  services.geoclue2.enable = true;
  services.geoclue2.enableDemoAgent = false; # GNOME has its own geoclue agent

  # authorise for these apps
  services.geoclue2.appConfig.gnome-datetime-panel = {
    isAllowed = true;
    isSystem = true;
  };
  services.geoclue2.appConfig.gnome-color-panel = {
    isAllowed = true;
    isSystem = true;
  };
  services.geoclue2.appConfig."org.gnome.Shell" = {
    isAllowed = true;
    isSystem = true;
  };

  environment.pathsToLink = [
    "/share"
  ];

  # colour profiles for monitors, printers etc
  services.colord.enable = true;

  environment.etc = {
    "chromium/native-messaging-hosts/org.gnome.browser_connector.json".source =
      "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.browser_connector.json";
    "opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json".source =
      "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json";
    # Legacy paths.
    "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
      "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
    "opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
      "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
  };
}
