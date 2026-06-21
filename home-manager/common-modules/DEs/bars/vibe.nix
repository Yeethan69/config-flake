{
  inputs,
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (lib.attrByPath [ "DE" "bar" ] null vars == "vibe") {
    nixpkgs.overlays = [
      inputs.vibe.overlays.default
    ];
    home.packages = with pkgs; [
      vibepanel
      cava
    ];
    systemd.user.services."vibepanel" = {
      Unit = {
        Description = "Vibepanel";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.vibepanel}/bin/vibepanel";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    xdg.configFile."vibepanel/config.toml" = {
      text = ''
        [bar]
        screen_margin = 8

        [widgets]
        left = ["workspaces", "window_title", "weather"]
        center = ["media"]
        right = ["tray", "quick_settings", "clock", "notifications"]

        [theme]
        mode = "auto"
      '';
    };
  };
}
