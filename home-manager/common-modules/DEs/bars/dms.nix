{
  inputs,
  lib,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nix-community/home-manager/b8bb556ce5abe5bbc10acb7508ef273b053f647d/modules/programs/quickshell.nix";
      sha256 = "0vbpiwqhxbc8nwybpznzqmyshs1659ivrs954nnrz3hi6igr3wxy";
    })
  ];
  config = lib.mkIf (lib.attrByPath [ "DE" "bar" ] null vars == "dms") {
    programs.dankMaterialShell = {
      enable = true;
      enableSystemd = true;
      enableClipboard = true;
      enableVPN = true;
      enableBrightnessControl = true;
      enableNightMode = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableSystemSound = true;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    # DMS has its own version of these.
    services.mako.enable = lib.mkForce false;
    services.swayidle.enable = lib.mkForce false;
    systemd.user.services.copyq = lib.mkForce { };
  };
}
