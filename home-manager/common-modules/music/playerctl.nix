{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (lib.elem "playerctl" vars.music) {
    home.packages = [
      pkgs.playerctl
    ];
    services.playerctld.enable = true;
  };
}
