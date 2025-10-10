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
  };
}
