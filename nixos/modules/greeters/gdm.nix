{
  vars,
  lib,
  ...
}:
{
  config = lib.mkIf (vars.greeter == "gdm") {
    services.xserver.displayManager.gdm.enable = true;
  };
}
