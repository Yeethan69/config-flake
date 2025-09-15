{ lib, vars, ... }:
{
  config = lib.mkIf (lib.getAttrFromPath [ "virt" "lg" "enable" ] vars) {
    programs.looking-glass-client = {
      settings = {
        win = {
          fullScreen = true;
          showFPS = true;
          jitRender = true;
          fpsMin = 144;
        };

        spice = {
          captureOnStart = true;
        };
      };
    };
  };
}
