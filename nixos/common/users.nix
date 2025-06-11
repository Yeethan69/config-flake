{ pkgs, ... }:
{
  users.users = {
    ethan = {
      isNormalUser = true;
      description = "Ethan";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
    elsa = {
      isNormalUser = true;
      description = "Elsa";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };
}
