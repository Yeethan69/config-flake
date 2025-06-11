{ pkgs, ... }:
{
  theme-name = "black-metal";
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
