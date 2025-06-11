{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (lib.hasAttr "waybar" vars.DE && vars.DE.waybar.enable == true) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "graphical-session.target";
    };
  };
}
