{ pkgs, lib, config, options, ... }: {

  xsession.windowManager.awesome = {
    enable = true;
    package = pkgs.writeShellScriptBin "awesome" ''
    ${pkgs.systemd}/bin/systemd-cat -t awesome ${pkgs.awesome}/bin/awesome
    '';
  };

  workingFiles.enable = true;

  workingFiles.file.awesomeConfig.linkSource = ".config/nix/home/awesome";
  # 
  home.file.awesomeConfig = {
      enable = true;
      source = ./awesome;
      recursive = true;
      target = ".config/awesome";
  };

  home.packages = with pkgs; [ xsecurelock picom nitrogen xscreensaver xidlehook brightnessctl playerctl ];

  services.screen-locker = {
    enable = true;

    xautolock.enable = false;
    inactiveInterval = 10;

    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    lockCmdEnv = [
      # "XSECURELOCK_PAM_SERVICE=xsecurelock"
      "XSECURELOCK_BLANK_TIMEOUT=-1"
      "XSECURELOCK_SAVER=saver_xscreensaver"
      # "XSECURELOCK_DISCARD_FIRST_KEYPRESS=1"
    ];
  };
  systemd.user.services.xss-lock.Unit = {
      ConditionEnvironment = "XDG_SESSION_TYPE=x11";
      ConditionPathExists = "/tmp/.X11-unix/X0";
  };
  # The home manager module tries to enable dpms when xss-lock starts so this just removes that
  systemd.user.services.xss-lock.Service.ExecStartPre = lib.mkForce "";
  # there is probably a much better way to do this 
  systemd.user.services.x11-idle-disable = {
    Unit = {
      Description = "Disable X11 DPMS and screen blanking";
      PartOf = [ "graphical-session.target" ];
      After  = [ "graphical-session.target" "xss-lock.service" ];
      ConditionEnvironment = "XDG_SESSION_TYPE=x11";
      ConditionPathExists = "/tmp/.X11-unix/X0";
    };
  
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "x11-idle-disable" ''
        echo "Disabling dpms idle"
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.xorg.xset}/bin/xset s noblank
        ${pkgs.xorg.xset}/bin/xset -dpms
      '';
      Environment = [
        "DISPLAY=:0"
        "XAUTHORITY=%h/.Xauthority"
      ];
    };
  
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.sockets.xidlehook = {
    Unit = {
      Description = "xidlehook control socket";
      PartOf = [ "xidlehook.service" ];
      ConditionEnvironment = "XDG_SESSION_TYPE=x11";
      ConditionPathExists = "/tmp/.X11-unix/X0";
    };

    Socket = {
      ListenStream = "%t/xidlehook.sock";
      SocketMode = "0600";
      RemoveOnStop = true;              # clean up socket when stopped
    };

    Install = { };
  };

  systemd.user.services.xidlehook = {
    Unit = {
      Description = "xidlehook (idle detector; asks logind to lock)";

      Requires = [ "xidlehook.socket" ];
      Wants = [ "xidlehook.socket" ];
      After    = [ "xidlehook.socket" "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_SESSION_TYPE=x11";
      ConditionPathExists = "/tmp/.X11-unix/X0";
    };
    Service = {
      Type = "simple";

      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.xidlehook}/bin/xidlehook" 
        # "--not-when-fullscreen" 
        "--socket" "%t/xidlehook.sock" 
        "--timer" 
            (builtins.toString ((config.services.screen-locker.inactiveInterval - 1)*60))
            "'${pkgs.brightnessctl}/brightnessctl set 30%'" 
            "'${pkgs.brightnessctl}/brightnessctl set 100%'"
        "--timer" 
            (builtins.toString ((config.services.screen-locker.inactiveInterval)*60))
            "'${pkgs.brightnessctl}/bin/brightnessctl set 100%; ${pkgs.systemd}/bin/loginctl lock-session; ${pkgs.systemd}/bin/systemctl suspend'" 
            "''"
        ];

      Environment = [
        "DISPLAY=:0"
        "XAUTHORITY=%h/.Xauthority"
      ];

      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
  
  systemd.user.services.media-pauses-xidlehook = {
    Unit = { 
        Requires = [ "xidlehook.service" "xidlehook.socket" ];
        BindsTo  = [ "xidlehook.service" ];
        PartOf   = [ "xidlehook.service" ];
        After = [ "xidlehook.service" "xidlehook.socket" ];
    };
    Service = {
      Type = "simple";
      Environment = [ "XIDLEHOOK_SOCK=%t/xidlehook.sock" ];
      ExecStart = pkgs.writeShellScript "media-pauses-xidlehook" ''
        set -euo pipefail
        echo "trying to connect to xidlehook on $XIDLEHOOK_SOCK"
        xic() {
            ${pkgs.xidlehook}/bin/xidlehook-client --socket "$XIDLEHOOK_SOCK" control --action "$@"
        }
        activate()   { echo "activate"; xic Enable   >/dev/null; echo "activated"; }
        deactivate() { echo "deactivate"; xic Disable >/dev/null; echo "deactivated" ;}
        # enable xidlehook if the script crashes
        trap 'activate || true' EXIT INT TERM
        
        # activate xidlehook just in case
        activate || true

        echo "starting main loop"
        while IFS= read -r st; do
          case "$st" in
            Playing) deactivate ;;
            Paused|Stopped|"") activate ;;
          esac
        done < <(${pkgs.playerctl}/bin/playerctl -a --follow status 2>/dev/null)
        echo "finished main loop"
      '';
      Restart = "always";
      RestartSec = 1;
    };
    Install = { WantedBy = [ "xidlehook.service" ]; };
  };
}
