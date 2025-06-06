{ lib, vars, ... }:
{
  config = lib.mkIf (vars.discord == "vesktop") {
    programs.vesktop = {
      enable = true;
      settings = {
        appBadge = false;
        arRPC = true;
        checkUpdates = false;
        customTitleBar = false;
        disableMinSize = true;
        minimizeToTray = true;
        tray = true;
        splashBackground = "#000000";
        splashColor = "#ffffff";
        splashTheming = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        disableMinSize = true;
      };
    };
  };
}
