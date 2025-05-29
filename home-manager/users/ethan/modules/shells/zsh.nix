{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.shell == "zsh") {
  };
}
