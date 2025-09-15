{
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=8086:3e98"
    ];

    blacklistedKernelModules = [
      "i915"
    ];
  };
}
