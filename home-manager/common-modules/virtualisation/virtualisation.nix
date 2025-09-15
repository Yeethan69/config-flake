{ lib, vars, ... }:
{
  config = lib.mkIf (lib.hasAttr "virt" vars && vars.virt.enable == true) {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
