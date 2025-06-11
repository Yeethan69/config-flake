{
  inputs,
  lib,
  vars,
  ...
}:
{
  imports = with inputs; [
    nvf.homeManagerModules.default
  ];

  config = lib.mkIf (lib.elem "neovim" vars.editors) {
    programs.nvf = {
      enable = true;

      settings.vim = {
        vimAlias = true;
        enableLuaLoader = true;
        diagnostics = {
          enable = true;
        };
      };
    };
  };
}
