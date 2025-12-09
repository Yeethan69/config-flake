{
  inputs,
  lib,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];
  config = lib.mkIf (lib.attrByPath [ "DE" "bar" ] null vars == "dms") {
    programs.dankMaterialShell = {
      enable = true;
      enableSystemd = true;
      enableClipboard = true;
      enableVPN = true;
      enableBrightnessControl = true;
      enableNightMode = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableSystemSound = true;
    };
    # DMS has its own version of these.
    services.mako.enable = lib.mkForce false;
    services.swayidle.enable = lib.mkForce false;
    systemd.user.services.copyq = lib.mkForce { };
  };
}
