{
  pkgs,
  lib,
  userNames,
  ...
}:
{
  users.users = lib.genAttrs userNames (name: {
    isNormalUser = true;
    description =
      lib.toUpper (builtins.substring 0 1 name) + lib.substring 1 (builtins.stringLength name - 1) name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  });
}
