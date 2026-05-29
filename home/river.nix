{ lib, pkgs, pkgs-unstable, options, config, ... }: {
    home.packages = [ pkgs-unstable.eww  pkgs.awww ];

  systemd.user.targets.river-session.Unit = {
    Description = "river-session";
    RefuseManualStart="yes";
    StopWhenUnneeded="yes";
    BindsTo          = [ "graphical-session.target" ];
    PropagatesStopTo = [ "graphical-session.target" ];
    Before           = [ "graphical-session.target" ];
  };

  systemd.user.targets.river-session-pre.Unit = {
    Description="Session services which should run before the river session is brought up";
    Documentation="man:systemd.target(5)";
    RefuseManualStart="yes";
    StopWhenUnneeded="yes";
    BindsTo          =["graphical-session-pre.target"];
    PropagatesStopTo =["graphical-session-pre.target"];
    Before           =[ "graphical-session-pre.target" "river-session.target"];
  };


  systemd.user.services.river = {
    Unit = {
      Description = "River";

      BindsTo          = [ "river-session.target" ];
      PropagatesStopTo = [ "river-session.target" ];
      Before           = [ "river-session.target" ];
      Wants            = [ "river-session-pre.target" ];
      After            = [ "river-session-pre.target" ];
    };

    Service = {
      Type = "notify";
      EnvironmentFile = "-%h/.config/river/env";
      ExecStart = "${pkgs-unstable.river}/bin/river";
      Restart = "on-failure";
      RestartSec = "2";
      NotifyAccess = "all";
      ExecStopPost = "${pkgs.systemd}/bin/systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY";
      Slice = "session.slice";
    };

    # Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.window-manager = {
    Unit = {
      PartOf    = [ "river-session.target" ];
      After     = [ "river-session.target" ];
      Requisite = [ "river-session.target" ];
    };
    Service = {
      Type="exec";
      Restart = "Always";
      ExecStart = "/home/trent/Documents/code/rust/orilla/target/release/orilla";
      RestartSec = "2";
      Slice = "session.slice";
    };
    Install.WantedBy = [ "river-session.target" ];
  };

  xdg.configFile."river/init" = {
  executable = true;
  text = ''
    #!/usr/bin/env bash
    # Make sure these environment variables are set for future systemd services.
    # Aternatively use `dbus-update-activation-environment --system` for these.
    systemctl --user import-environment  WAYLAND_DISPLAY DISPLAY XCURSOR_SIZE

    # Tell systemd startup is complete.
    systemd-notify --ready

    # execute the window manager
    # exec ~/Documents/code/rust/orilla/target/release/orilla
  '';
  };

  systemd.user.services."awww-daemon@river" = {
    Unit = {
      Description = "Animated Background Daemon";

      PartOf    = [ "river-session.target" ];
      After     = [ "river-session.target" ];
      Requisite = [ "river-session.target" ];
      # ConditionEnvironment = "XDG_SESSION_TYPE=x11";
      # ConditionPathExists = "/tmp/.X11-unix/X0";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart="on-failure";
      Slice = "session.slice";

      # pkgs.writeShellScript "x" ''
      #   echo "Disabling dpms idle"
      #   ${pkgs.awww}/bin/awww
      # '';
      # Environment = [
      #   "DISPLAY=:0"
      #   "XAUTHORITY=%h/.Xauthority"
      # ];
    };

    Install.WantedBy = [ "river-session.target" ];
  };


  # systemd.user.services.x11-idle-disable = {
  #   Unit = {
  #     Description = "Disable X11 DPMS and screen blanking";
  #     PartOf = [ "graphical-session.target" ];
  #     After  = [ "graphical-session.target" "xss-lock.service" ];
  #     # ConditionEnvironment = "XDG_SESSION_TYPE=x11";
  #     ConditionPathExists = "/tmp/.X11-unix/X0";
  #   };
  # 
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = pkgs.writeShellScript "x11-idle-disable" ''
  #       echo "Disabling dpms idle"
  #       ${pkgs.xorg.xset}/bin/xset s off
  #       ${pkgs.xorg.xset}/bin/xset s noblank
  #       ${pkgs.xorg.xset}/bin/xset -dpms
  #     '';
  #     Environment = [
  #       "DISPLAY=:0"
  #       "XAUTHORITY=%h/.Xauthority"
  #     ];
  #   };
  # 
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
  #
  # systemd.user.sockets.xidlehook = {
  #   Unit = {
  #     Description = "xidlehook control socket";
  #     PartOf = [ "xidlehook.service" ];
  #     # ConditionEnvironment = "XDG_SESSION_TYPE=x11";
  #     ConditionPathExists = "/tmp/.X11-unix/X0";
  #   };
  #
  #   Socket = {
  #     ListenStream = "%t/xidlehook.sock";
  #     SocketMode = "0600";
  #     RemoveOnStop = true;              # clean up socket when stopped
  #   };
  #
  #   Install = { };
  # };
  #
  # systemd.user.services.xidlehook = {
  #   Unit = {
  #     Description = "xidlehook (idle detector; asks logind to lock)";
  #
  #     Requires = [ "xidlehook.socket" ];
  #     Wants = [ "xidlehook.socket" ];
  #     After    = [ "xidlehook.socket" "graphical-session.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #     # ConditionEnvironment = "XDG_SESSION_TYPE=x11";
  #     ConditionPathExists = "/tmp/.X11-unix/X0";
  #   };
  #   Service = {
  #     Type = "simple";
  #
  #     ExecStart = builtins.concatStringsSep " " [
  #       "${pkgs.xidlehook}/bin/xidlehook" 
  #       # "--not-when-fullscreen" 
  #       "--socket" "%t/xidlehook.sock" 
  #       "--timer" 
  #           (builtins.toString ((config.services.screen-locker.inactiveInterval - 1)*60))
  #           "'${pkgs.brightnessctl}/bin/brightnessctl set 30%'" 
  #           "'${pkgs.brightnessctl}/bin/brightnessctl set 100%'"
  #       "--timer" 
  #           (builtins.toString ((config.services.screen-locker.inactiveInterval)*60))
  #           "'${pkgs.brightnessctl}/bin/brightnessctl set 100%; ${pkgs.systemd}/bin/loginctl lock-session; ${pkgs.systemd}/bin/systemctl suspend'" 
  #           "''"
  #       ];
  #
  #     Environment = [
  #       "DISPLAY=:0"
  #       "XAUTHORITY=%h/.Xauthority"
  #     ];
  #
  #     Restart = "on-failure";
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
    
}
