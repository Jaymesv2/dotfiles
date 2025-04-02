{ pkgs, lib, config, ... }: {
    imports = [ ./hardware/marc_laptop.nix ];

    boot.kernelParams = [ "button.lid_init_state=open" ];
    #boot.kernelPackages = pkgs.linuxPackages_latest;

    services.thermald.enable = true;
    powerManagement.enable = true;
    powerManagement.powertop.enable = lib.mkForce false;
    services.power-profiles-daemon.enable = false;

    services.tlp = {
        enable = true;
        settings = {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_BOOST_ON_BAT = 0;
            CPU_MAX_PER_ON_BAT=60;
        };
    };

    # Nvidia Configuration 
    services.xserver.videoDrivers = [ "nvidia" ]; 

    hardware.graphics = {
        enable = true;
    };
    
    nixpkgs.config.nvidia.acceptLicense = true;

    hardware.nvidia = {
        open = false;
        # Optionally, you may need to select the appropriate driver version for your specific GPU. 
        package = config.boot.kernelPackages.nvidiaPackages.stable; 
        # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway 
        modesetting.enable = true; 

        nvidiaSettings = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;

        prime = { 
            sync.enable = true; 
            # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
            intelBusId = "PCI:0:2:0"; 
            # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
            nvidiaBusId = "PCI:1:0:0"; 
        };
    };
    


    # Load nvidia driver for Xorg and Wayland
    specialisation = {
      nogpu.configuration = {
        hardware.nvidia.prime = {
          sync.enable = pkgs.lib.mkForce false;

          offload = {
            enable = pkgs.lib.mkForce true;
            enableOffloadCmd = pkgs.lib.mkForce true;
          };
        };

        boot.extraModprobeConfig = ''
          blacklist nouveau
          options nouveau modeset=0
        '';
    
        services.udev.extraRules = ''
          # Remove NVIDIA USB xHCI Host Controller devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA USB Type-C UCSI devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA Audio devices, if present
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
          # Remove NVIDIA VGA/3D controller devices
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
        '';
        boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
      };
    };

}
