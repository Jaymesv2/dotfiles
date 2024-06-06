{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: rec {
  imports = [
    home/nvim/nvim.nix
    home/zsh/zsh.nix
    home/alacritty.nix
    home/waybar.nix
    home/ssh.nix
    home/git.nix
    #home/emacs.nix
  ];
  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "23.11";
    packages = with pkgs; [
      # ----- SYSTEM -----

      # fonts
      fira-code-nerdfont

      cinnamon.nemo

      libnotify

      # ----- cli tools -----
      lnav    
      tree
      gnumake
      wget
      htop
      zip
      p7zip
      loc
      jq
      yq
      btop
      pandoc
      fzf
      #globalprotect-openconnect
      wireguard-tools
      tmux
      findutils

      ripgrep
      fd
      ctags


      # ----- languages -----
      swiProlog

      # ----- system stuff -----
      networkmanagerapplet
      pavucontrol
      flameshot
      gnome.gnome-software
      gnome.file-roller
      cinnamon.nemo-fileroller
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
        okular
	    notepadqq
        
        # other
        qbittorrent
        qjournalctl
	
        
        #
        zathura
        sxiv
        vlc

        # crypto 
        ledger-live-desktop
        monero-gui
        monero-cli


        # drive recovery
        diskscan
        parted
        gnomecast
        gnome.gnome-disk-utility
        gparted


        # games
        ckan
	#osu-lazer-bin
	prismlauncher
	graalvm-ce

	nix-gaming.packages.x86_64-linux.osu-stable
	nix-gaming.packages.x86_64-linux.osu-lazer-bin
      
    ] ++ [
        pkgs-unstable.devenv
    ];
    sessionVariables = {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";

      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      TERM = "alacritty";

      NIXOS_OZONE_WL = "1";
    };
  };
  
  programs.home-manager.enable = true;


  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop;";
	"application/cbz" = "mcomix.desktop";
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

  xsession.windowManager.awesome = {
    enable = true;
    package = pkgs.writeShellScriptBin "awesome" ''
    ${pkgs.systemd}/bin/systemd-cat -t awesome ${pkgs.awesome}/bin/awesome
    '';
  };
  
  # pkgs.writeShellScriptBin "hello" ''
  # Call hello with a traditional greeting 
  #exec ${pkgs.hello}/bin/hello -t

  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };


  programs.mpv.enable = true;
  
  programs.firefox.enable = true;

  programs.gpg = {
    enable = true;
  };
  services.gpg-agent.enable = true;

  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  
  services.mpd.enable = true;
  
  programs.direnv = {
    enable = true;
    config = {};
  };
  
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      
    ];
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

