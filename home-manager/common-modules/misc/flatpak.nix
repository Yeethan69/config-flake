{
  inputs,
  lib,
  vars,
  ...
}:
{
  imports = with inputs; [
    nix-flatpak.homeManagerModules.nix-flatpak
  ];
  config = lib.mkIf (lib.getAttrFromPath [ "flatpak" "enable" ] vars) {
    services.flatpak.enable = true;
    services.flatpak.packages =
      if (lib.hasAttr "packages" vars.flatpak) then vars.flatpak.packages else [ ];
    services.flatpak.overrides =
      if (lib.hasAttr "overrides" vars.flatpak) then vars.flatpak.overrides else { };
  };
}
