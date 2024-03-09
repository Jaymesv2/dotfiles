# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
  #extraOptions = ''
  #  experimental-features = nix-command flakes
  #'';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-9a777e5b-11f1-4bff-b65a-4427855f3cc0".device = "/dev/disk/by-uuid/9a777e5b-11f1-4bff-b65a-4427855f3cc0";
  networking.hostName = "nixos"; # Define your hostname.

  services.udev.packages = with pkgs; [
    ledger-udev-rules
    libu2f-host
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # ----- Bluetooth -----
  hardware.bluetooth = {
    enable = true;
  };



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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  # Optionally, you may need to select the appropriate driver version for your specific GPU. 
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


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trent = {
    isNormalUser = true;
    description = "Trent";
    group = "trent";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  programs.zsh.enable = true;


  users.groups.trent = {};


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    
    neovim
    pulseaudio

    # Required for the system
    brightnessctl
    acpi
    

    alacritty
    neofetch
    usbutils
    zsh
    wireguard-tools

    greetd.gtkgreet
    cage
  ];

  services.flatpak.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  services.xserver = {
    # dpi = 166;
    enable = true;
    layout = "us";
    xkbVariant = "";
    wacom.enable = true;
    libinput = {
      touchpad.naturalScrolling = false;
      touchpad.accelProfile = "flat";
    };
    logFile = "/dev/null";
    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;

      };
    };
    displayManager.defaultSession = "xsession";
    displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = ''exec $HOME/.xsession'';
      }
    ];
    # windowManager.awesome = {
    #   enable = true;
    #   luaModules = with pkgs.luaPackages; [
    #     luarocks
    #   ];
    # };
    #dpi = 180;
  };


  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "cage -s -- gtkgreet";
  #     };
  #   };
  # };

  #programs.regreet.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
