{ lib, pkgs, pkgs-unstable, ... }: rec {
  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "23.11";
    packages = with pkgs; [
      # ----- SYSTEM -----
      # fonts
      fira-code-nerdfont

      cinnamon.nemo

      tofi
      #eww-wayland
      htop
      pavucontrol

      hyprpaper
      hyprpicker
      gnumake

      qjournalctl
      lnav    
      libnotify
      zathura
      wget

      # ----- cli tools -----
      jq
      yq
      pandoc
      fzf

      # ----- applications -----
      
      discord
      signal-desktop
      thunderbird
      logseq
      obsidian
      libreoffice
      todoist-electron
      qbittorrent
      wireguard-tools
      networkmanagerapplet

      #wg-netmanager
      
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

  imports = [
    
  ];

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop;";
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
    # xdg.configFile = {
    #     "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #     "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #     "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    # };
  };


  fonts.fontconfig.enable = true;

  services.mako = {
    enable = true;
    defaultTimeout = 10000;
  };

  # xresources.extraConfig = ''
  #   Xft.dpi: 141
  # '';

  xsession.windowManager.awesome = {
    enable = true;
  };



  xsession.enable = true;



  # programs.thunderbird.enable = true;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   enableNvidiaPatches = true;
  #   xwayland.enable = true;
  # };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Arc";
  #     package = pkgs.arc-theme;
  #   };
  # };

  programs.alacritty = {
    enable = true;
    settings = {
      #font.size = 8.0;
      "font.normal".family = "MesloLGS NF";
      window = {
        decorations = "full";
        decorations_theme_variant = "Dark";
        dynamic_padding = false;
        dynamic_title = true;
        opacity = 0.7;
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ./init.vim;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      vim-gitgutter
      fzf-vim
      fzf-lua
      ale
      nerdtree
      nerdtree-git-plugin
      vim-multiple-cursors
      onedark-nvim
      vim-fugitive
      neomake
      vimspector
      markdown-preview-nvim
    ];


  };


  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  #programs.wofi.enable = true;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.gpg = {
    enable = true;

  };
  services.gpg-agent.enable = true;
  services.gpg-agent.enableZshIntegration = true;

  programs.ssh = {
    enable = true;
    #addKeysToAgent = "yes";
    matchBlocks = {
      "10.0.0.246".user = "trent";
      "10.0.0.1".extraOptions = {
	  PubkeyAcceptedAlgorithms = "+ssh-rsa";
    	  HostkeyAlgorithms = "+ssh-rsa";
      };
      "cs*.utdallas.edu" = {
	user = "tlt210003";
	setEnv = {
	  TERM = "xterm";
	};
      };
      "borg" = {
 	match = "user backup host \"10.0.10.20\"";
	identityFile = "~/.ssh/borg_ed25519";
	serverAliveCountMax = 30;
	serverAliveInterval = 10;
	# nix doesnt recognize this :(
	#passwordAuthentication = "no";
      };
    };

  };
  services.mpd.enable = true;

  services.ssh-agent.enable = true;
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1"];
        modules-left = [ 
          "hyprland/workspaces" 
          "hyprland/mode" 
          "wlr/taskbar" 
        ];
        modules-center = [ "hyprland/window"];
        modules-right = [ 
          "tray" 
          "bluetooth"
          "cpu"
          #"disk"
          "memory"
          #"mpd" 
          "temperature" 
          "network"
          "pulseaudio"
          #"pulseaudio/slider"
          #"privacy"
          "upower"
          "clock"
          #"user"
          # 
          #"group" 
        ];
        "hyprland/workspaces" = {      
          disable-scroll = true;      
          all-outputs = true;    
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        # "custom/hello-from-waybar" = {      
        #   format = "hello {}";      
        #   max-length = 40;      
        #   interval = "once";      
        #   exec = pkgs.writeShellScript "hello-from-waybar" ''        echo "from within waybar"      '';    
        #   };  
        # };
      };
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    config = {};
  };
  programs.git = {
    enable = true;
    userEmail = "ghastfilms613@gmail.com";
    userName = "Trent";
    # signing = {
    #   signByDefault = true;
    #   key = "";
    #   gpgPath = "";
    # };
  };

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
	"belak/zsh-utils path:editor"
	"belak/zsh-utils path:history"
	"belak/zsh-utils path:prompt"
	"belak/zsh-utils path:utility"
	"belak/zsh-utils path:completion"
	"ohmyzsh/ohmyzsh"
	"zsh-users/zsh-autosuggestions"
	"zsh-users/zsh-syntax-highlight"
	#"pkulev/zsh-rustup-completion"
	"sunlei/zsh-ssh"
	#"dbz/kube-aliases"


      ];

      # what does this do?
      #useFriendlyNames = true;

    };
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "git"
    #     "gpg-agent"
    #     "vi-mode"
    #   ];
    # };

    initExtra = ''
      zstyle ':completion:*' menu select
    '';

    shellAliases = {
      "hm"   = "home-manager";
      "vim"  = "nvim";
      "vi"   = "nvim";
      "v"    = "nvim";
      "ls"   = "ls --color=auto";
      "l"    = "ls --color=auto";
      "df"   = "df -h";
      "du"   = "du -h -c";
      "cls"  = "clear";
      "step" = "step-cli";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "p10kConfig";
        src = ./p10k;
        file = "p10k.zsh";
      }
    ];

  };


  
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      
    ];
  };
}

