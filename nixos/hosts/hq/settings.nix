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
    efiResolution = "3840x1080";
    resolution = "5120x1440";
    refresh = 144.0;
  };
  drivers.graphics = "nvidia";
}
