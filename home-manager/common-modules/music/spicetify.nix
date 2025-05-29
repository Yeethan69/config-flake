{
  inputs,
  vars,
  lib,
  ...
}:
{
  imports =
    if (lib.elem "spicetify" vars.music) then
      (with inputs; [
        spicetify-nix.homeManagerModules.spicetify
      ])
    else
      [ ];
  config = lib.mkIf (lib.elem "spicetify" vars.music) {
    stylix.targets.spicetify.enable = false;
    programs.spicetify = {
      enable = true;
      experimentalFeatures = true;
    };
  };
}
