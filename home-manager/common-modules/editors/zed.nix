{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (lib.elem "zed" vars.editors) {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        buffer_font_fallbacks = [
          "Font Awesome 6 Free"
          "Symbols Nerd Font Mono"
        ];
        buffer_font_features = {
          "calt" = true;
          "liga" = true;
          "dlig" = true;
        };
      };
    };
  };
}
