{ lib, vars, ... }:
{
  config = lib.mkIf (lib.getAttrFromPath [ "virt" "lg" "enable" ] vars) {
    programs.looking-glass-client = {
      enable = true;
    };
  };
}
