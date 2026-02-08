{ pkgs, lib, config, options, ...} : {
    #imports = [./hardware/new_laptop.nix];
    imports = [ ./hardware/laptop/disk.nix ./hardware/laptop/hardware-configuration.nix ./secureboot.nix ];
    # fileSystems."/var/log".neededForBoot = true;

    boot.initrd.systemd.network.wait-online.enable = false;
    systemd.network.wait-online.enable = false;
    boot.loader.timeout = 1;

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
    #linuxPackages-cachyos-latest;
    # linux-cachyos-latest-lto-zen4
    # linux-cachyos-bore-lto

    services.acpid.enable = true;
    # detect when the system is connected to ac power 
    powerManagement.enable = true;
    # powertop enables autosuspend on the framework 16s keyboard and I can't figure out how to prevent it form doing that
    powerManagement.powertop.enable = lib.mkForce false;
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;

    services.fprintd.enable = true;
    services.upower.enable = true;

    services.xserver.videoDrivers = [ "amdgpu" ]; 

    hardware.graphics = {
        enable = true;
    };

    environment.systemPackages = with pkgs; [ linux-firmware ];

    hardware.enableRedistributableFirmware = true;

    # services.udev.extraRules = lib.mkAfter ''
    #     SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    #     SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    # '';


  boot.initrd.systemd.services.recreate-root = {
    description = "Rolling over and creating new filesystem root";

    wantedBy = [ "initrd.target" ];
    requires = [ "initrd-root-device.target" ];
    after = [
      "initrd-root-device.target"
      "local-fs-pre.target"
    ];
    before = [
      "sysroot.mount"
      "create-needed-for-boot-dirs.service"
    ];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    script = let 
        root_name = "root";
        luks_name = "cryptroot";
    in ''
      echo "impermanence: starting btrfs cleanup"
      mkdir /btrfs_tmp
      echo "impermanence: mounting ${luks_name} to /btrfs_tmp"
      if [[ ! -e /dev/mapper/${luks_name} ]]; then
        echo "/dev/mapper/${luks_name} was not found"
      fi

      mount /dev/mapper/${luks_name} /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          echo "impermanence: moving current root to old roots"
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          echo "impermanence: recursively deleting old root $i"
          delete_subvolume_recursively "$i"
      done

      echo "impermanence: creating new root volume"
      btrfs subvolume create /btrfs_tmp/root
      echo "impermanence: unmounting /btrfs_tmp"
      umount /btrfs_tmp

    '';
  };
}
