{
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."luks-eec9716f-2186-47a2-84f0-bf3f1fc2ca55".crypttabExtraOpts = [
    "fido2-device=auto"
    "timeout=60"
  ];
}
