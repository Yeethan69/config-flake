{
  inputs,
  lib,
  vars,
  ...
}:
{
  imports =
    if lib.elem "neovim" vars.editors then
      (with inputs; [
        nvf.homeManagerModules.default
      ])
    else
      [ ];

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
