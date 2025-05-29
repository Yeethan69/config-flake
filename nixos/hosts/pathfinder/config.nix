{
  swapDevices = [
    { device = "/swapfile"; }
  ];
  powerManagement.enable = true;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=${toString (60 * 15)}s
    SuspendState=mem
  '';
}
