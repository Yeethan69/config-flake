{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.terminal == "kitty") {
  };
}
