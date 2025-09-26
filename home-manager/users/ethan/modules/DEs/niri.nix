{
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.DE.name == "niri") {
    programs.niri = {
      settings = {

      };
    };
  };

}
