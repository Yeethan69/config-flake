{ ... }:
{
  swapDevices = [
    { device = "/swapfile"; }
  ];

  boot.kernelParams = [ "resume_offset=12691456" ];
  boot.resumeDevice = "/dev/disk/by-uuid/2f058807-e05a-4367-944c-ec56757be701";
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."luks-eec9716f-2186-47a2-84f0-bf3f1fc2ca55".crypttabExtraOpts = [
    "fido2-device=auto"
    "timeout=60"
  ];

  powerManagement.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=yes
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
