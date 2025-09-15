{ lib, vars, ... }:
{
  config = lib.mkIf (lib.getAttrFromPath [ "virt" "lg" "enable" ] vars) {
    programs.looking-glass-client = {
      settings = {
        win = {
          fullScreen = false;
          showFPS = true;
          fpsMin = 144;
        };

        spice = {
          captureOnStart = true;
        };
      };
    };
  };
}
