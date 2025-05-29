{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.DE.name == "niri") {
    programs.niri = {
      settings = {
        window-rules = [
          {
            # Firefox PiP
            matches = [ { title = "Picture-in-Picture"; } ];
            open-floating = true;
            open-focused = false;
            default-floating-position = {
              relative-to = "bottom-right";
              x = 16;
              y = 16;
            };
          }
          {
            # Volume Control
            matches = [ { app-id = "org.pulseaudio.pavucontrol"; } ];
            open-floating = true;
            open-focused = true;
            default-floating-position = {
              relative-to = "top-right";
              x = 16;
              y = 16;
            };
          }
        ];
      };
    };
  };

}
