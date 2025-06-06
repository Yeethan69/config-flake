{ pkgs, ... }:
{
  base16-theme = "${pkgs.base16-schemes}/share/themes/black-metal.yaml";
  theme-name = "black-metal-base16";
  greeter = "tuigreet";
  plymouth = {
    enable = true;
    theme = "";
  };
  bootloader = "grub";
  display = {
    efiResolution = "1920x1200";
    resolution = "2880x1800";
    refresh = 120.0;
  };
  drivers.graphics = "intel";
}
