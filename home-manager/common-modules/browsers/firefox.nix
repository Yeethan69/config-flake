{
  vars,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (vars.browser == "firefox") {
    programs.firefox.enable = true;
    stylix.targets.firefox = {
      enable = true;
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
    };

    # make firefox open links without overriding mimeapps.list (xdg.mimeapps.enable = true)
    home.activation.set-firefox-for-browsers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      xdg_mime=${pkgs.xdg-utils}/bin/xdg-mime

      mimes=(
        text/html
        x-scheme-handler/http
        x-scheme-handler/https
        x-scheme-handler/about
        x-scheme-handler/unknown
      )

      for m in "''${mimes[@]}"; do
        cur="$($xdg_mime query default "$m" 2>/dev/null || true)"
        if [ -z "$cur" ] || [ "$cur" != "firefox.desktop" ]; then
          run $xdg_mime default firefox.desktop "$m"
        fi
      done
    '';
  };
}
