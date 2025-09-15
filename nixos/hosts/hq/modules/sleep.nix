{
  swapDevices = [
    { device = "/swapfile"; }
  ];

  boot.kernelParams = [ "resume_offset=12691456" ];
  boot.resumeDevice = "/dev/disk/by-uuid/2f058807-e05a-4367-944c-ec56757be701";

  powerManagement.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=yes
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
