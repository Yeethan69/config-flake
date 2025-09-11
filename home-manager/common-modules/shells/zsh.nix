{
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.shell == "zsh") {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "thefuck"
        ];
      };

      dotDir = ".config/zsh";

      initContent = ''
        # Powerlevel10k Zsh theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        if [[ -e ~/.config/zsh/.p10k.zsh ]]; then

          grep -qc custom_nix_shell ~/.config/zsh/.p10k.zsh || ${pkgs.gnused}/bin/sed -i -z '/typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(\n/s/=\n/\n    customnixshell\n/' ~/.config/zsh/.p10k.zsh

          # Show Shell Level
          function prompt_customnixshell() {
            if [[ $IN_NIX_SHELL =~ impure ]]; then
              p10k segment -b 1 -f 3 -i '󰏖'
            fi
          }

          source ~/.config/zsh/.p10k.zsh
        fi

        # Nix shell nixpkgs#... func
        try() {
          local args=()
          for pkg in "$@"; do
            args+="nixpkgs#$pkg"
          done
          IN_NIX_SHELL=impure NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "''${args[@]}"
        }

        # Get hashes for fetchers
        get-hash() {
          if [ "$#" -ne 1 ]; then
            echo "Usage: get-hash <url>"
            return 1
          fi
          nix-prefetch-url "$1" | xargs nix hash convert --hash-algo sha256
        }
      '';
    };

    programs.thefuck.enable = true;
  };
}
