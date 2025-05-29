{ vars, lib, ... }:
{
  config = lib.mkIf (vars.plymouth.enable == true) {
    boot.plymouth = {
      enable = true;
      #theme = "sphere";
      #themePackages = with pkgs; [
      #  (adi1090x-plymouth-themes.override { selected_themes = [ "sphere" ]; })
      #];
    };
  };
}
