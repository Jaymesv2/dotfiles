{ pkgs, lib, config, options, ...} : {
    #imports = [./hardware/new_laptop.nix];

    imports = [ ./hardware/laptop/disk.nix ./hardware/laptop/hardware-configuration.nix ];
    

    # boot.kernelParams = [ "amdgpu.abmlevel=0" "mt7925e.disable_aspm=1"];


    # boot.extraModprobeConfig = ''
    #   options mt7925e disable_aspm=1
    # '';
    # networking.wireless.driver = "mt7921e";

    services.acpid.enable = true;
    services.thermald.enable = true;
    powerManagement.enable = true;
    powerManagement.powertop.enable = lib.mkForce false;
    services.power-profiles-daemon.enable = false;
    services.fprintd.enable = true;


    # Nvidia Configuration 
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
