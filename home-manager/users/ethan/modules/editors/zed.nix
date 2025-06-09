{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (lib.elem "zed" vars.editors) {
    programs.zed-editor = {
      extensions = [ "nix" ];

      extraPackages = [
        pkgs.nixd
        pkgs.nil
        pkgs.nixfmt-rfc-style
        pkgs.package-version-server
      ];

      userSettings = {
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter = {
              external = {
                command = "nixfmt";
              };
            };
          };
        };
        tab_size = 2;
      };
    };
  };
}
