{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config =
    let
      startUserDEScript = pkgs.writeShellScriptBin "start-user-de" ''
        set -e # Exit on error
        source $HOME/.de
        exec $DE > /dev/null
      '';
    in
    lib.mkIf (vars.greeter == "tuigreet") {
      services.greetd = {
        enable = true;
        settings = {
          default_session =
            let
              tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
              tuigreetOptions = [
                "--cmd ${startUserDEScript}/bin/start-user-de"
              ];
              flags = lib.concatStringsSep " " tuigreetOptions;
            in
            {
              command = "${tuigreet} ${flags}";
              user = "greeter";
            };
        };
      };
    };
}
