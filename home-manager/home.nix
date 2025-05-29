{
  inputs,
  pkgs,
  lib,
  userName,
  ...
}:
let
  moduleFiles = lib.filesystem.listFilesRecursive ./common-modules;
  modules = lib.filter (f: lib.strings.hasSuffix ".nix" (toString f)) moduleFiles;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  imports =
    with inputs;
    [
      stylix.homeModules.stylix
      prism.homeModules.prism
    ]
    ++ lib.optionals (builtins.pathExists ./users/${userName}/config.nix) [
      ./users/${userName}/config.nix
    ]
    ++ modules;

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    packages = (import ./users/${userName}/packages.nix) { inherit pkgs; };
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
