{ lib, vars, ... }:
{
  config = lib.mkIf (lib.hasAttr "media" vars && lib.elem "kodi" vars.media) {
    programs.kodi.enable = true;
  };
}
