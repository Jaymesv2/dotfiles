# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, pkgs-unstable, ... }: let something = "something"; in {
  imports =
    [ ../../../network.nix
      ../../../laptop.nix
      ../../../sops.nix
      ../../../audio.nix
      ../../../printer.nix
      ../../../graphics.nix
      ../../../modules/nixos/nix.nix
      ../../../persist.nix
    ];
    

  # nix = {
  #   # pkgs.nixFlakes is an alias for pkgs.nixVersions.stable
  #   package = pkgs.nixVersions.stable;
  #   gc = {
  #       automatic = true;
  #       persistent = true;
  #       randomizedDelaySec = "45min";
  #   };
  #
  #   settings = {
  #     experimental-features = [ "nix-command" "flakes" ];
  #     substituters = [
  #       "https://nix-gaming.cachix.org"
  #       "https://cache.garnix.io"
  #     ];
  #     trusted-public-keys = [
  #       "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
  #       "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #     ];
  #     trusted-users = [
  #       "root"
  #       "trent"
  #       "@wheel"
  #     ];
  #   };
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";


  # Bootloader.
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  services.udev.packages = with pkgs; [
    ledger-udev-rules
    libu2f-host
    yubikey-personalization
  ];

    # emulate aarch64 for building rpi images
  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];




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

      # extraPkgs = p: with p; [ glxinfo ];
      extraPkgs = p: with p; [ mesa-demos ];
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
  # enable tpm
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trent = {
    isNormalUser = true;
    description = "Trent";
    group = "trent";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "tss" ];
    packages = with pkgs; [];
    hashedPassword = "$y$j9T$PoIVXXZUTD0aNXvUtlmyK/$VJH7ZxK7V9Caq99dpvrjPhJY/nKrjrzBpHZYSdBWu53";
    # hashedPasswordFile = config.sops.secrets.trent-password.path;
    # initialPassword = "123abc"; # best password
  };
  users.users.root.hashedPassword = "$y$j9T$ibbF4vj1t1WEmM9WEgk7E.$igM9JiPYciGdJnzP5Rxg8hUNovpl.SMMsFLsxZOWsw6";

  # sops.secrets.trent-password.neededForUsers = true;
  programs.zsh.enable = true;

  users.groups.trent = {};

  # virtualization stuff
  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };



  # services.globalprotect.enable = true;

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
    kopia
    # globalprotect-openconnect
  ];

  services.flatpak.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };


  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
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
