{
  lib,
  vars,
  pkgs,
  config,
  hostName,
  ...
}:
{
  config = lib.mkIf (lib.elem "zed" vars.editors) {
    programs.zed-editor = {
      extensions = [ "nix" ];

      extraPackages = [
        pkgs.nixd
        pkgs.nil
        pkgs.nixfmt
        pkgs.package-version-server
      ];

      userSettings = {
        languages = {
          Nix = {
            language_servers = [
              "!nil"
              "nixd"
            ];
            formatter = {
              external = {
                command = "nixfmt";
              };
            };
          };
        };
        lsp = {
          nixd = {
            settings = {
              options = {
                home-manager = {
                  expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos\").homeConfigurations.\"${config.home.username}@${hostName}\".options";
                };
              };
            };
          };
        };
        tab_size = 2;
        features = {
          edit_prediction_provider = "copilot";
        };
      };
    };
  };
}
