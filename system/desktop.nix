{ pkgs, lib, config, options, ...} : {
    imports = [ ./hardware/desktop/disk.nix ./hardware/desktop/hardware-configuration.nix ./secureboot.nix ];

    boot.initrd.systemd.network.wait-online.enable = false;
    systemd.network.wait-online.enable = false;
    boot.loader.timeout = 1;
    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
      libratbag
      linux-firmware 
      input-remapper
      nvtopPackages.amd
      rocmPackages.rocm-smi
      solaar
    ];
    services.input-remapper.enable = true;
    # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

    # detect when the system is connected to ac power 
    # powerManagement.enable = true;


    services.xserver.videoDrivers = [ "amdgpu" ]; 

    hardware.graphics = {
        enable = true;
    };

    hardware.amdgpu.overdrive.enable = true;
    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.rules = 
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];


    services.udev.packages = [
        (pkgs.writeTextFile {
            name  = "42-logitech-unify-permissions.rules";
                # Type=XSession
            text = ''
# This rule was added by Solaar.
#
# Allows non-root users to have raw access to Logitech devices.
# Allowing users to write to the device is potentially dangerous
# because they could perform firmware updates.
KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

ACTION == "remove", GOTO="solaar_end"
SUBSYSTEM != "hidraw", GOTO="solaar_end"

# USB-connected Logitech receivers and devices
ATTRS{idVendor}=="046d", GOTO="solaar_apply"

# Lenovo nano receiver
ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6042", GOTO="solaar_apply"

# Bluetooth-connected Logitech devices
KERNELS == "0005:046D:*", GOTO="solaar_apply"

GOTO="solaar_end"

LABEL="solaar_apply"

# Allow any seated user to access the receiver.
# uaccess: modern ACL-enabled udev
TAG+="uaccess"

# Grant members of the "plugdev" group access to receiver (useful for SSH users)
#MODE="0660", GROUP="plugdev"

LABEL="solaar_end"
# vim: ft=udevrules
            '';
            destination = "/etc/udev/rules.d/42-logitech-unify-permissions.rules";
        })


    ];


    services.xserver.xrandrHeads = [
        {
            primary = true;
            output = "DisplayPort-2";
            # output = "Screen 0";
            monitorConfig = ''
                Option "PreferredMode" "2560x1440"
                Option "PreferredRefresh" "144"
            '';
        }
    ];
    services.xserver.inputClassSections = 
 [''
  Identifier "libinput pointer catchall"
  MatchIsPointer "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "AccelProfile" "flat"
  Option "Emulate3Buttons" "no"
  Option "MiddleEmulation" "false"
 ''
 # ''
 #  Identifier "Disable Middle Emulation"
 #  MatchIsPointer "yes"
 #  Option "MiddleEmulation" "false"
 # ''
 ];

    services.xserver.displayManager.sessionCommands = ''
      xset m 0 0
    '';

    # environment.systemPackages = with pkgs; [ 
    # ];



    hardware.enableRedistributableFirmware = true;

  # I don't think this will work with the raid 1
  # boot.initrd.systemd.services.recreate-root = {
  #   description = "Rolling over and creating new filesystem root";
  #
  #   wantedBy = [ "initrd.target" ];
  #   requires = [ "initrd-root-device.target" ];
  #   after = [
  #     "initrd-root-device.target"
  #     "local-fs-pre.target"
  #   ];
  #   before = [
  #     "sysroot.mount"
  #     "create-needed-for-boot-dirs.service"
  #   ];
  #
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #
  #   script = let 
  #       root_name = "root";
  #       luks_names = ["crypt0" "crypt1"];
  #   in ''
  #     echo "impermanence: starting btrfs cleanup"
  #     mkdir /btrfs_tmp
  #
  #     for luks_name in ${toString (builtins.concatStringsSep " " luks_names)}; do
  #       if [[ ! -e /dev/mapper/$luks_name ]]; then
  #         echo "Error: /dev/mapper/$luks_name was not found"
  #         exit 1
  #       fi
  #     done
  #
  #     # mount /dev/mapper/${luks_names} /btrfs_tmp
  #     mount /dev/mapper/crypt1 /btrfs_tmp
  #     if [[ -e /btrfs_tmp/root ]]; then
  #         echo "impermanence: moving current root to old roots"
  #         mkdir -p /btrfs_tmp/old_roots
  #         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #         mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #     fi
  #
  #     delete_subvolume_recursively() {
  #         IFS=$'\n'
  #         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #             delete_subvolume_recursively "/btrfs_tmp/$i"
  #         done
  #         btrfs subvolume delete "$1"
  #     }
  #
  #     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #         echo "impermanence: recursively deleting old root $i"
  #         delete_subvolume_recursively "$i"
  #     done
  #
  #     echo "impermanence: creating new root volume"
  #     btrfs subvolume create /btrfs_tmp/root
  #     echo "impermanence: unmounting /btrfs_tmp"
  #     umount /btrfs_tmp
  #
  #   '';
  # };
}
