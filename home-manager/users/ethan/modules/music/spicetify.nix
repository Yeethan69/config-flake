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
      theme = spicePkgs.themes.dribbblish;
      colorScheme = "purple";
      enabledSnippets = [
        # https://github.com/spicetify/spicetify-themes/issues/1159#issuecomment-2705286541
        ''.encore-dark-theme, .encore-dark-theme .encore-base-set{--background-base:rgba(0,0,0,0);}''
      ];
    };
  };
}
