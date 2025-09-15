{
  userNames,
  config,
  pkgs,
  ...
}:
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = userNames;
  users.groups.kvm.members = userNames;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      verbatimConfig = ''
        namespaces = []
        cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/userfaultfd",
            "/dev/kvmfr0"
        ]
      '';
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
  boot.kernelModules = [ "kvmfr" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.kernelParams = [ "kvmfr.static_size_mb=128" ];
  services.udev.extraRules = ''
    KERNEL=="kvmfr0", SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660"
  '';
}
