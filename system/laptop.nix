{ pkgs, lib, config, options, ...} : {
    #imports = [./hardware/new_laptop.nix];
    imports = [ ./hardware/laptop/disk.nix ./hardware/laptop/hardware-configuration.nix ./hardware/laptop/secureboot.nix ];
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
}
