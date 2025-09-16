{ lib, vars, ... }:
{
  config = lib.mkIf (lib.getAttrFromPath [ "virt" "lg" "enable" ] vars) {
    programs.looking-glass-client = {
      settings = {
        win = {
          fullScreen = false;
          showFPS = true;
          fpsMin = 144;
          size = "2560x1440";
        };

        egl = {
          scale = 1;
        };

        spice = {
          captureOnStart = true;
        };
      };
    };
  };
}
