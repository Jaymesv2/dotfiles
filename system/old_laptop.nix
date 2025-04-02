{ pkgs, config, options, ... }: {
    imports = [ ./hardware/old_laptop.nix ];

  # ------ POWER MANAGEMENT
  services.acpid.enable = true;
  services.upower.enable = true;
  powerManagement.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;


  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
       governor = "powersave";
       turbo = "never";
    };
    charger = {
       governor = "performance";
       turbo = "auto";
    };
  };

  # Nvidia Configuration 
  services.xserver.videoDrivers = [ "nvidia" ]; 

  hardware.graphics = {
    enable = true;
  };

  nixpkgs.config.nvidia.acceptLicense = true;
  
  # Optionally, you may need to select the appropriate driver version for your specific GPU. 
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; 
  
  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway 
  hardware.nvidia.modesetting.enable = true; 
  
  hardware.nvidia.prime = { 
    sync.enable = true; 
  
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
    nvidiaBusId = "PCI:1:0:0"; 
  
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA 
    intelBusId = "PCI:0:2:0"; 
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
