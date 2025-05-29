{
  vars,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf (vars.drivers.graphics == "nvidia") {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    boot.initrd.kernelModules = [ "nvidia" ];
    boot.kernelParams = [ "video=DP-2:${vars.display.resolution}@${toString vars.display.refresh}" ];
    console.earlySetup = true;
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
