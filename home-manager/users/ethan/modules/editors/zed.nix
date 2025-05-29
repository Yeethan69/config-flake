{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (lib.elem "zed" vars.editors) {
  };
}
