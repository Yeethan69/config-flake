{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.DE.waybar.enable == true) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "graphical-session.target";
    };
  };
}
