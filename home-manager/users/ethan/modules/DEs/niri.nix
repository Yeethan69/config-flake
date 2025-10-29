{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (vars.DE.name == "niri") {
    systemd.user.services.birdtray = {
      Unit = {
        Description = "Tray application for thunderbird";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.birdtray}/bin/birdtray";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "DISPLAY=\":0\""
        ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    home.file.bird = {
      target = "Documents/tb.sh";
      text = ''
        #! ${pkgs.runtimeShell}
        export GDK_BACKEND=x11
        ${pkgs.thunderbird}/bin/thunderbird
      '';
      executable = true;
    };

    programs.niri = {
      settings = {
        spawn-at-startup = [
          { command = [ "systemctl --user restart birdtray.service" ]; }
        ];
      };
    };
  };

}
