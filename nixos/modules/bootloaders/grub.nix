{ vars, lib, ... }:
{
  config = lib.mkIf (vars.bootloader == "grub") {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      gfxmodeEfi = vars.display.efiResolution;
      configurationLimit = 5;
    };
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
