{
  vars,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf (vars.drivers.graphics == "intel") {
    hardware.graphics.extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];
  };
}
