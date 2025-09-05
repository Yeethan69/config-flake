{
  lib,
  vars,
  pkgs,
  ...
}:
let
  extraCompatPackages = with pkgs; [ proton-ge-bin ];
  extraCompatPaths = lib.makeSearchPathOutput "steamcompattool" "" extraCompatPackages;
in
{
  config = lib.mkIf (vars.steam.enable == true) {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      noto-fonts-emoji
      source-han-sans

      protontricks

      gamescope
      mangohud

      (steam.override {
        extraEnv = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = extraCompatPaths;
        };
      })
    ];

    # You can also set a user-specific environment variable this way
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = extraCompatPaths;
    };
  };
}
