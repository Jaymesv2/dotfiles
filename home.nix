{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: let 
    # https://discourse.nixos.org/t/nix-flamegraph-or-profiling-tool/33333
    stackCollapse = pkgs.writeTextFile {
      name = "stack-collapse.py";
      destination = "/bin/stack-collapse.py";
      text = builtins.readFile (builtins.fetchurl
        {
          url = "https://raw.githubusercontent.com/NixOS/nix/master/contrib/stack-collapse.py";
          sha256 = "sha256:0mi9cf3nx7xjxcrvll1hlkhmxiikjn0w95akvwxs50q270pafbjw";
        });
      executable = true;
    };
    nixFunctionCalls = pkgs.writeShellApplication {
      name = "nixFunctionCalls";
      runtimeInputs = [ stackCollapse pkgs.inferno ];
      text = ''
#!/usr/bin/env zsh

WORKDIR=$(mktemp -d)

nix eval -vvvvvvvvvvvvvvvvvvvv --raw --option trace-function-calls true $1 1>/dev/null 2> $WORKDIR/nix-function-calls.trace
stack-collapse.py $WORKDIR/nix-function-calls.trace > $WORKDIR/nix-function-calls.folded
inferno-flamegraph $WORKDIR/nix-function-calls.folded > $WORKDIR/nix-function-calls.svg
echo "$WORKDIR/nix-function-calls.svg"
      ''; #./nix-function-calls.sh;
      checkPhase = "";
    };

in rec {
  imports = [
    # home/nvim/nvim.nix
    modules/home-manager/nvim/nvim.nix
    modules/home-manager/zsh/zsh.nix
    home/alacritty.nix
    home/waybar.nix
    home/ssh.nix
    home/git.nix
    home/emacs/emacs.nix
    home/sops.nix
    home/java.nix
    home/awesome.nix
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

  # hardware.enableRedistributableFirmware = true;
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "23.11";
    packages = 
        ([ nixFunctionCalls stackCollapse ] ) ++ (with pkgs; [
      # ----- SYSTEM -----

      # fonts
      nerd-fonts.fira-code


      nemo

      libnotify

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
        discord
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
  
  programs.home-manager.enable = true;

  
  xdg = {
    #enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # config.common.default = "*";
      config = {
        common = {
          default = [
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "nemo"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
        x-gnome = {
          default = [
            "gtk"
          ];
        };
      };
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let 
        document_viewer = "org.pwmt.zathura-pdf-mupdf.desktop;";
        image_viewer = "sxiv.desktop";
        video_player = "vlc.desktop";
        archive_viewer = "org.gnome.FileRoller.desktop";
    in {
      # documents
        "application/pdf" = document_viewer;
        "application/vnd.amazon.ebook" = document_viewer;
        "application/epub+zip" = document_viewer;
        #"text/html" = "firefox.desktop";


      # images
        "image/jpeg" = image_viewer;
        "image/webp" = image_viewer;
        "image/png" = image_viewer;
        "image/gif" = image_viewer;

        "image/apng" = image_viewer;
        "image/avif" = image_viewer;
        "image/vnd.microsoft.icon" = image_viewer;
        
      # audio

      # video
        "video/mp4" = video_player;
        "video/x-msvideo" = video_player; # .avi

      # archives
        "application/x-bzip" = archive_viewer; # .bz
        "application/x-bzip2" = archive_viewer; # .bz2
        "application/gzip" = archive_viewer;
        "application/x-gzip" = archive_viewer;
        
      # misc
        #"application/octet-stream" = "";
        #"text/calendar" = "";
      };
      #defaultApplications = {
      #  "word"
      #};
    };
    userDirs = {
      enable = true;
      createDirectories = true;

      extraConfig = {
        XDG_MISC_DIR = "${home.homeDirectory}/Misc";
      };
    };
    #  I think I need to add these to XDG_DATA_DIRS or PATH
    # '/var/lib/flatpak/exports/share'
    # '/home/trent/.local/share/flatpak/exports/share'


    # xdg.configFile = {
    #     "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #     "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #     "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    # };
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

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Arc";
  #     package = pkgs.arc-theme;
  #   };
  # };
  



  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   enableNvidiaPatches = true;
  #   xwayland.enable = true;
  # };
  # programs.thunderbird.enable = true;


}

