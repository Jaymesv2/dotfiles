{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: rec {
  imports = [
    # home/nvim/nvim.nix
    ../modules/home-manager/nvim/nvim.nix
    ../modules/home-manager/zsh/zsh.nix
    ./alacritty.nix
    ./waybar.nix
    ./ssh.nix
    ./git.nix
    # emacs/emacs.nix
    ./sops.nix
    ./java.nix
    ./awesome.nix
    ./television.nix
    ./xdg.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
    #"qtwebengine-5.15.19"
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: 
    builtins.elem (lib.getName pkg) [
      "discord"
      "obsidian"
      "todoist-electron"
      "vscode"
      "burpsuite"
  ];

  # automatically create the home manager symlink
  home.activation.homeManagerSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln $VERBOSE_ARG -sfnT "${home.homeDirectory}/.config/nix" "${home.homeDirectory}/.config/home-manager"
  '';

  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "23.11";
    sessionVariables = {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";

      XDG_CURRENT_DESKTOP="GNOME";

      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      TERM = "alacritty";
      
      # NIXOS_OZONE_WL = "1"; # Needed for electron on wayland
    };
  };

  programs.home-manager.enable = true;
  news.display = "silent";
  nixpkgs.overlays = [ (import ../pkgs/overlay.nix) ];

  home.packages = (with pkgs; [
      nixFunctionCalls stackCollapse 
      # ----- SYSTEM -----

      # fonts
      nerd-fonts.fira-code

      phoronix-test-suite
      nemo

      libnotify
      bubblewrap
      # ----- cli tools -----
      lnav
      tree
      gnumake
      wget
      htop
      zip
      unzip
      p7zip
      tokei
      jq
      yq
      btop
      pandoc
      fzf
      xclip
      #globalprotect-openconnect
      wireguard-tools
      findutils

      kopia

      wireshark

      hexchat

      ripgrep
      fd
      ctags
      just

      # yubikey-personalization-gui
      yubioath-flutter
      #yubikey-manager-qt
      # ----- languages -----
      swi-prolog
      # ----- system stuff -----
      networkmanagerapplet
      pavucontrol
      flameshot
      gnome-software

      file-roller
      nemo-fileroller
      # peazip

      # ----- applications -----
    
        # communication
        # discord
        signal-desktop
        thunderbird
        qpwgraph
        element-desktop

        # productivity
        logseq
        obsidian
        libreoffice
        todoist-electron
        pdfmixtool
        # libsForQt5.okular
	    #notepadqq
        
        # other
        qjournalctl
        audacity
        easyeffects
	
        
        #
        zathura
        sxiv
        vlc

        prusa-slicer
        #freecad
        librecad

        # crypto 
        ledger-live-desktop
        monero-gui
        monero-cli

        #rpi-imager

        # drawing
        inkscape


        # drive recovery
        diskscan
        parted
        gnomecast
        gnome-disk-utility
        gparted


        # games
        ckan


        kdePackages.skanpage
        epsonscan2
        burpsuite

        sops

        zotero
        ymuse
        alsa-utils


	#osu-lazer-bin
	prismlauncher
    packwiz

	graalvmPackages.graalvm-ce
    kopia
    kopia-ui
      
    ]) ++ [
        pkgs-unstable.devenv
        pkgs-unstable.qbittorrent
	    # nix-gaming.packages.x86_64-linux.osu-stable
	    # nix-gaming.packages.x86_64-linux.osu-lazer-bin
  ];


  programs.discord = {
    enable = true;
    settings = {
        SKIP_HOST_UPDATE=true;
        DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING=true;
    };
  };

  # 'programs.vicinae'.
  # setup home manager `backupCommand`
  # services.local-ai

  # `services.home-manager.autoUpgrade.useFlake = true;`.
/*
* 2025-10-11 00:06:01 [unread]

  A new option is availabe: `home-manager.minimal`
  
  By default, Home Manager imports all modules, which leads to increased
  evaluation time. Some users may wish to only import the modules they
  actually use. When the new option is enabled, Home Manager will only
  import the basic set of modules it requires to function. Other modules
  will have to be enabled manually, like this:
  
  ```nix
    imports = [
      "${modulesPath}/programs/fzf.nix"
    ];
  ```


  anime-downloader

'services.home-manager.autoExpire'.
'services.linux-wallpaperengine'.
*/
  programs.nushell = {
    enable = true;
    environmentVariables= {

    };

    # plugins = with pkgs.nushellPlugins; [ 
    #     formats 
    #     dbus
    #     units
    #     query
    #     skim
    #     net
    # ];

  };
  

  

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };



  fonts.fontconfig.enable = true;

  xsession.enable = true;

  # pkgs.writeShellScriptBin "hello" ''
  # Call hello with a traditional greeting 
  #exec ${pkgs.hello}/bin/hello -t

  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  


  programs.mpv.enable = true;
  
  programs.firefox.enable = true;

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

  #services.dbus.packages = [ pkgs.gcr ];

  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  
  services.mpd.enable = true;
  
  programs.vscode = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
    options = {
        selection-clipboard = "clipboard";
    };
  };

}

