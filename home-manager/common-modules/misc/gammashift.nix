{ lib, vars, ... }:
{
  config = lib.mkIf (lib.hasAttr "gammashift" vars && vars.gammashift.enable == true) {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
    };
  };
}
