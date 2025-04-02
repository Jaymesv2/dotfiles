# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, pkgs-unstable, ... }: let something = "something"; in {
  imports =
    [ ./network.nix
      ./marc_laptop.nix
      ./sops.nix
      ./audio.nix
      # ./postgres.nix
      ./graphics.nix
    ];
    
  nix = {
    # pkgs.nixFlakes is an alias for pkgs.nixVersions.stable
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
      trusted-users = [
        "root"
        "trent"
        "@wheel"
      ];
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";


  # Bootloader.
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-9a777e5b-11f1-4bff-b65a-4427855f3cc0".device = "/dev/disk/by-uuid/9a777e5b-11f1-4bff-b65a-4427855f3cc0";
  networking.hostName = "nixos"; # Define your hostname.

  services.udev.packages = with pkgs; [
    ledger-udev-rules
    libu2f-host
    yubikey-personalization
  ];

    # emulate aarch64 for building rpi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];




  services.fwupd.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;


  # Set your time zone.
  time.timeZone = "America/Chicago";
  # time.timeZone = "America/New_York";


  # ------------ STEAM -------------
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      #withJava = true;
      #withPrimus = true;

      extraPkgs = p: with p; [ glxinfo ];
    };
  };
  programs.java.enable = true;




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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [];

    initialPassword = "123abc"; # best password
  };
  programs.zsh.enable = true;

  users.groups.trent = {};

  # virtualization stuff
  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  virtualisation.docker = {
    enable = true;
  };

  services.globalprotect.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    qemu
    neovim

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
    dig
    globalprotect-openconnect
  ];

  services.flatpak.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };


  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # (nerdfonts.override { } )
  ];

  # Why is this here on 24.05??
  services.displayManager = {
    defaultSession = "xsession";
  };



  services.libinput = {
    touchpad.naturalScrolling = false;
    touchpad.accelProfile = "flat";
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


  programs.nix-ld.enable = true;
  environment.variables = {
    #NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
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
