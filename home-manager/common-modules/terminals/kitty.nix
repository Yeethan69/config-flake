{
  pkgs,
  lib,
  vars,
  ...
}:
{
  config =
    let
      kittySymbolsNerdFontPath = "${pkgs.kitty}/lib/kitty/fonts/SymbolsNerdFontMono-Regular.ttf";
      symbolsNerdFontFromKittyPkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "symbols-nerd-font-from-kitty";
        version = pkgs.kitty.version;
        src = kittySymbolsNerdFontPath;
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src $out/share/fonts/truetype/SymbolsNerdFontMono-FromKitty.ttf
        '';

        dontBuild = true;
        dontConfigure = true;
        dontFixup = true;
        doCheck = false;
      };
    in
    lib.mkIf (vars.terminal == "kitty") {
      programs.kitty.enable = true;
      home.packages = [
        symbolsNerdFontFromKittyPkg
      ];
    };
}
