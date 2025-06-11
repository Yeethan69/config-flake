{
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.DE.name == "gnome") {
    programs.gnome-shell = {
     enable = true;
     extensions = [
       { package = pkgs.gnomeExtensions.blur-my-shell; }
       { package = pkgs.gnomeExtensions.burn-my-windows; }
       { package = pkgs.gnomeExtensions.compiz-windows-effect; }
       { package = pkgs.gnomeExtensions.wallpaper-slideshow; }
       { package = pkgs.gnomeExtensions.dash-to-panel; }
       { package = pkgs.gnomeExtensions.gtk4-desktop-icons-ng-ding; }
     ];
    };
  };
}
