{
  inputs,
  vars,
  lib,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.x86_64-linux;
in
{
  config = lib.mkIf (lib.elem "spicetify" vars.music) {
    programs.spicetify = {
      windowManagerPatch = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        betterLibrary
      ];
      theme = spicePkgs.themes.blossom;
    };
  };
}
