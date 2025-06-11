{
  vars,
  lib,
  ...
}:
{
  config = lib.mkIf (vars.browser == "firefox") {
    programs.firefox.enable = true;
    stylix.targets.firefox = {
      enable = true;
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
    };
  };
}
  
