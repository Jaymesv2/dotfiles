{ lib, pkgs, options, config, ... }: let
  vfioDevices = [ "10de:2d05" "10de:22eb" ];
  # this is the host gpu
  gpuVendor = "0x1002";
  gpuDevice = "0x7550";
  gpuPCI = "16:0:0";
  symlinkName = "9070-card";


  # looking glass
  
  # 2560x1440 sdr
  lookingGlassBufferSize = 128;
in {
  # virtualisation = {
  #   libvirtd = {
  #       enable = true;
  #       qemu = {
  #           package = pkgs.qemu_kvm;
  #           swtpm.enable = true;
  #       };
  #   };
  # };
  # environment.systemPackages = [ pkgs.virt-manager ];
  # users.users.trent.extraGroups = [ config.users.groups.podman.name "libvirtd" "kvm" ];

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",
        "/dev/kqemu",
        "/dev/rtc", "/dev/hpet",
        "/dev/kvmfr0"
    ]
  '';

  virtualisation.libvirtd.hooks.qemu = let 
    maxRetries = 6;
    unpinnedCores = "8-15,24-31";
    in { win11  = pkgs.writeShellScript "libvirt-qemu-hook" ''
        exec >> /var/log/libvirt-hook.log 2>&1
        echo "=== $(date -Is) invoked with: $* ==="
        set -x

        GUEST="$1"
        OP="$2"

        if [ "$GUEST" = "win11" ]; then
          case "$OP" in
            started)
              # tell systemd not to schedule anything on these cores
              systemctl set-property --runtime system.slice AllowedCPUs=${unpinnedCores}
              systemctl set-property --runtime user.slice AllowedCPUs=${unpinnedCores}
              systemctl set-property --runtime init.slice AllowedCPUs=${unpinnedCores}

              systemd-run --uid=trent \
                --setenv=XDG_RUNTIME_DIR=/run/user/1000 \
                --setenv=WAYLAND_DISPLAY=wayland-1 \
                --unit=looking-glass-launch -- /bin/sh -c '
                  #i=0
                  #while [ "$i" -lt 6 ]; do
                    /run/current-system/sw/bin/looking-glass-client -s spice:clipboard=yes && break
                    #/run/current-system/sw/bin/sleep 5
                    #i=$((i+1))
                  #done
                '
              ;;
            stopped)
              systemctl set-property --runtime system.slice AllowedCPUs=0-31
              systemctl set-property --runtime user.slice AllowedCPUs=0-31
              systemctl set-property --runtime init.slice AllowedCPUs=0-31
              systemctl stop looking-glass-launch
              ;;
          esac
        fi
    '';
  };

  # environment.etc."libvirt/hooks/qemu" = let
  #   maxRetries = 6;
  # in {
  #   source = 
  #   mode = "0755";
  # };


  # persist software tpm directory
  environment.persistence."/persistent".directories = [
      { directory = "/var/lib/libvirt"; user = "root"; group = "root"; mode="u=rwx,g=rx,o=rx"; } 
      { directory = "/var/lib/swtpm-localca"; user = "tss"; group = "tss"; mode="u=rwx,g=x,o=x"; }
  ];

  # this should create a symlink since to the 9070 since hyprland is retarded and thinks the `:` in the device path is a seperator
  services.udev.extraRules = ''
    KERNEL=="card*", SUBSYSTEM=="drm", ATTRS{vendor}=="${gpuVendor}", ATTRS{device}=="${gpuDevice}", SYMLINK+="dri/${symlinkName}"
    SUBSYSTEM=="kvmfr", OWNER="trent", GROUP="kvm", MODE="0660"
  '';
  environment.systemPackages = [ pkgs.looking-glass-client ];

  # Point hyprland at the gpu symlink
  environment.sessionVariables.AQ_DRM_DEVICES = 
    "/dev/dri/${symlinkName}";


  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "amdgpu"
    ];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=${lib.concatStringsSep "," vfioDevices}"
    ];

    blacklistedKernelModules = [ "nouveau" ];


    kernelModules = [ "kvmfr" ];
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

    # ensure vfio loads first and set looking glass buffer size
    extraModprobeConfig = ''
     softdep amdgpu pre: vfio-pci
     options kvmfr static_size_mb=${toString lookingGlassBufferSize}
    '';
  };


  services.xserver = {
    deviceSection = ''
      BusID "PCI:${gpuPCI}"
    '';
    config = ''
      Section "ServerFlags"
        Option "AutoAddGPU" "off"
      EndSection
    '';
  };
}

# { lib, pkgs, config, ... }:
# with lib;                      
# let
#   cfg = config.windowsVM;
# in {
#   custom.vm.nonboot-graphics = {
#     enable = true;
#     gpuVendor = "0x1002";
#     gpuDevice = "0x7550";
#     gpuPCIE = "16:0:0";
#     symlinkName = "9070-card";
#   }
#
#   # specify a sdifferent gpu than the one the motherboard boots to (fixes xorg and hyprland)
#   options.custom.vm.nonboot-graphics = {
#     enable = mkEnableOption "Use a non primary graphics card at boot";
#     gpuVendor = mkOption {
#       type = types.str;
#     };
#     gpuDevice = mkOption {
#       type = types.str;
#     };
#     gpuPCIE = mkOption {
#       type = types.str;
#     };
#     symlinkName = mkOption {
#       type = types.str;
#     };
#
#   };
#
#   config = mkIf cfg.enable {
#     services.udev.extraRules = ''
#       KERNEL=="card*", SUBSYSTEM=="drm", ATTRS{vendor}=="${cfg.gpuVendor}", ATTRS{device}=="${cfg.gpuDevice}", SYMLINK+="dri/${cfg.symlinkName}"
#     '';
#     services.xserver = {
#       deviceSection = ''
#         BusID "PCI:${cfg.gpuPCIE}"
#       '';
#       config = ''
#         Section "ServerFlags"
#           Option "AutoAddGPU" "off"
#         EndSection
#       '';
#     };
#   };
# }

