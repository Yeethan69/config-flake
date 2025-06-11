{
  inputs,
  lib,
  pkgs,
  vars,
  hostname,
  ...
}:
let
  moduleFiles = lib.filesystem.listFilesRecursive ./modules;
  modules = lib.filter (f: lib.strings.hasSuffix ".nix" (toString f)) moduleFiles;
  commonModuleFiles = lib.filesystem.listFilesRecursive ./common;
  commonModules = lib.filter (f: lib.strings.hasSuffix ".nix" (toString f)) commonModuleFiles;
in
{
  imports =
    with inputs;
    [
      stylix.nixosModules.stylix
      ./hosts/${hostname}/hardware-configuration.nix
    ]
    ++ lib.optionals (builtins.pathExists ./hosts/${hostname}/config.nix) [
      ./hosts/${hostname}/config.nix
    ]
    ++ modules
    ++ commonModules;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  security.pam.services.swaylock = { };
  services.gnome.gnome-keyring.enable = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${vars.theme-name}.yaml";
  
  environment.shells = [ pkgs.zsh ];

  system.stateVersion = "25.05";
}
