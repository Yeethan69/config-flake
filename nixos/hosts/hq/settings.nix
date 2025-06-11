{ ... }:
{
  theme-name = "black-metal";
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
