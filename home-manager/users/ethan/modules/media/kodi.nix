{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (lib.hasAttr "media" vars && lib.elem "kodi" vars.media) {
    programs.kodi = {
      sources = {
        files = {
          source = [
            {
              # Media
              name = "fen";
              path = "https://fenlightanonymouse.github.io/packages/";
              allowsharing = "true";
            }
            {
              # Scraper
              name = "coco";
              path = "https://cocojoe2411.github.io/";
              allowsharing = "true";
            }
            {
              # Games (Steam, Emulators, other executables etc)
              name = "AKL";
              path = builtins.toString (
                pkgs.stdenv.mkDerivation {
                  name = "AKL";
                  src = pkgs.fetchurl {
                    url = "https://github.com/chrisism/repository.chrisism/raw/refs/heads/master/repository/repository.chrisism/repository.chrisism-1.1.0.zip";
                    hash = "sha256-qaqS7LVCotZ3s6GrzldYrufZFoKegTSNQXodT8k55MU=";
                  };
                  dontUnpack = true;
                  installPhase = ''
                    mkdir -p $out
                    cp $src $out/repository.chrisism-1.1.0.zip
                  '';
                }
              );
              allowsharing = "true";
            }
            {
              # Clear cache etc
              name = "EZ Maintenance+";
              path = "https://peno64.github.io/repository.peno64/";
              allowsharing = "true";
            }
            {
              # Arctic fuse + Arctic Horizon (skins)
              name = "jurialmunkey";
              path = "https://jurialmunkey.github.io/repository.jurialmunkey/";
              allowsharing = "true";
            }
            {
              # YouTube
              name = "yt";
              path = "https://download.osmc.tv/dev/anxdpanic/repositories/";
              allowsharing = "true";
            }
            {
              # Different media plugin
              name = "pov";
              path = "https://kodiyashimaru.github.io/repo/";
              allowsharing = "true";
            }
          ];
        };
      };
    };
  };
}
