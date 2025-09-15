{ lib, ... }:
let
  moduleFiles = lib.filesystem.listFilesRecursive ./modules;
  modules = lib.filter (f: lib.strings.hasSuffix ".nix" (toString f)) moduleFiles;
in
{
  imports = modules;
}
