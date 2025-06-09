{
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (lib.elem "neovim" vars.editors) {
    programs.nvf = {
      settings.vim = {
        options = {
          tabstop = 2;
          shiftwidth = 0;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          inlayHints.enable = true;
          lightbulb.enable = true;
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;

          bash.enable = true;
          clang.enable = true;
          csharp.enable = true;
          css = {
            enable = true;
            format.type = "prettierd";
          };
          haskell.enable = true;
          html.enable = true;
          lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          python.enable = true;
        };

        # Plugins
        lazy.plugins = {
          vim-be-good = {
            package = pkgs.vimPlugins.vim-be-good;
          };
        };
      };
    };
  };
}
