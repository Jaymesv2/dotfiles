{ lib, pkgs, options, config, ... }: {

  programs.virt-manager.enable = true;

  virtualisation.containers.enable = true;

  virtualisation = {
    libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            swtpm.enable = true;
        };
    };
    # docker = {
    #   enable = true;
    #   enableOnBoot = false;
    # };
    podman = {
      enable = true;
      autoPrune.enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
      
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.groups.podman = {
    name = "podman";
  };

  environment.systemPackages = [ pkgs.virt-manager ];
  users.users.trent.extraGroups = [ config.users.groups.podman.name "libvirtd" "kvm" ];


  # this should create a symlink since to the 9070 since hyprland is retarded and thinks the `:` in the device path is a seperator
  # environment.sessionVariables.AQ_DRM_DEVICES = 
  #   "/dev/dri/9070-card";
  #  # "/dev/dri/by-path/pci-0000:12:00.0-card";
  # services.udev.extraRules = ''
  #   KERNEL=="card*", SUBSYSTEM=="drm", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x7550", SYMLINK+="dri/9070-card"
  # '';
  #  # ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x7480", ATTR{power/control}="on"
  #  # ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0xab30", ATTR{power/control}="on"
  # boot = {
  #   initrd.kernelModules = [
  #     "vfio_pci"
  #     "vfio"
  #     "vfio_iommu_type1"
  #     "amdgpu"
  #   ];
  #
  #   kernelParams = [
  #     # i don't feel like dealing with the bs rn
  #     # "pcie_aspm=off"
  #
  #     "amd_iommu=on"
  #     "iommu=pt"
  #     "vfio-pci.ids=1002:7480,1002:ab30"
  #   ];
  #
  #   # ensure vfio loads first
  #   extraModprobeConfig = ''
  #    softdep amdgpu pre: vfio-pci
  #   '';
  # };






  # for now podman on root won't persist

  # environment.persistence."/persistent" = {
  #   directories = [
  #     { directory = "/var/lib/containers"; user = "root"; group = "root"; mode="u=rwx,g=x,o="; }
  #   ];
  # };


}
