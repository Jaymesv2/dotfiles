{ pkgs, lib, config, options, ...} : {
    #imports = [./hardware/new_laptop.nix];

    imports = [ ./hardware/laptop/disk.nix ./hardware/laptop/hardware-configuration.nix ./hardware/laptop/secureboot.nix ];
    # fileSystems."/var/log".neededForBoot = true;
    
    # boot.kernelParams = [ "amdgpu.abmlevel=0" "mt7925e.disable_aspm=1"];


    # boot.extraModprobeConfig = ''
    #   options mt7925e disable_aspm=1
    # '';
    # networking.wireless.driver = "mt7921e";


    # ac-power is enabled when the system is connected to ac power :|
    systemd.targets.ac-power = {
        enable = true;
        description = "AC-only services";
    };
    
    systemd.services.toggle-ac-power = {
        description = "toggles between performance and balanced depending on power";
        
        partOf = ["ac-power.target"];
        wantedBy=["ac-power.target"];

        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit="yes";
            ExecStart = ''${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance'';
            ExecStop = ''${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced'';
        };
    };
    
    services.udev.extraRules = lib.mkAfter ''
        SUBSYSTEM=="power_supply", KERNEL=="AC*", ATTRS{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ac-power.target"
        SUBSYSTEM=="power_supply", KERNEL=="AC*", ATTRS{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop ac-power.target"
    '';

    # services.udev.extraRules = lib.mkAfter ''
    #     SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    #     SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    # '';
    
    
    services.acpid.enable = true;
    # detect when the system is connected to ac power 
    powerManagement.enable = true;
    # powertop enables autosuspend on the framework 16s keyboard and I can't figure out how to prevent it form doing that
    powerManagement.powertop.enable = lib.mkForce false;
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;

    services.fprintd.enable = true;

    

    # systemd.sleep.extraConfig = ''
    #     [Sleep]
    #     AllowSuspendThenHibernate=yes
    #     HibernateDelaySec=2h
    # '';

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
