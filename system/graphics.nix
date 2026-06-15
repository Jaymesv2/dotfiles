{ lib,pkgs, config, pkgs-unstable, ... }: let 
    # river-user-session = pkgs.writeShellScript "river-user-session" ''
    #     #!/usr/bin/env bash
    #
    #     # From: https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
    #
    #     # If the previous graphical session left some failed units, reset
    #     # them so that they don't break this startup.
    #     for unit in $(${pkgs.systemd}/bin/systemctl --user --no-legend --state=failed --plain list-units | ${pkgs.coreutils}/bin/cut -f1 -d' '); do
    #          partof="$(${pkgs.systemd}/bin/systemctl --user show -p PartOf --value "$unit")"
    #          for target in river-session.target graphical-session.target; do
    #                  if [ "$partof" = "$target" ]; then
    #                          ${pkgs.systemd}/bin/systemctl --user reset-failed "$unit"
    #                          break
    #                  fi
    #          done
    #     done
    #
    #     # Save environment variables that will be added to systemd.
    #     new_env=$(${pkgs.systemd}/bin/systemctl --user show-environment | ${pkgs.coreutils}/bin/cut -d'=' -f 1 | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/comm -13 - <(${pkgs.coreutils}/bin/env | ${pkgs.coreutils}/bin/cut -d'=' -f 1 | ${pkgs.coreutils}/bin/sort))
    #
    #     # Import environment variables from the login manager.
    #     ${pkgs.systemd}/bin/systemctl --user import-environment
    #
    #     # Start the service.
    #     ${pkgs.systemd}/bin/systemctl --wait --user start river.service
    #
    #     # Cleanup environment.
    #     ${pkgs.systemd}/bin/systemctl --user unset-environment $new_env
    #
    #     exit 0
    # '';
    awesome-user-session = pkgs.writeShellScript "awesome-user-session" ''
      #!/usr/bin/env bash
      set -e
      # Make X/D-Bus env visible to the user manager
      # ${pkgs.systemd}/bin/systemctl --user import-environment \
      #   DISPLAY XAUTHORITY \
      #   XDG_SESSION_ID XDG_SESSION_CLASS XDG_SESSION_TYPE \
      #   XDG_SEAT XDG_VTNR \
      #   DBUS_SESSION_BUS_ADDRESS

      # Import environment variables from the login manager.
      ${pkgs.systemd}/bin/systemctl --user import-environment

      # Start the session target and block until it exits
      ${pkgs.systemd}/bin/systemctl --user --wait start awesome.service

      exit 0
    '';
in{
  imports = [ ./cwc.nix ];

  
  services.displayManager = {
    sddm = {
      enable = true;
      # wayland.enable = true;
      # wayland.compositor = "weston";
    };
    # defaultSession = "awesome-session";
    defaultSession = "hyprland-uwsm";
    sessionPackages = [ 
        pkgs.weston 
        # (pkgs.writeTextFile {
        #     name  = "river-session.desktop";
        #     text = ''
        #         [Desktop Entry]
        #         Name=river-session
        #         Comment=Wayland Window Manager
        #         Exec=${river-user-session}
        #         Type=Application
        #     '';
        #     destination = "/share/wayland-sessions/river-session.desktop";
        #     passthru = {
        #         providedSessions = [ "river-session" ];
        #     };
        # })
        (pkgs.writeTextFile {
            name  = "awesome-session.desktop";
            text = ''
                [Desktop Entry]
                Name=Awesome Session
                Exec=${awesome-user-session}
                /home/trent/.xsession
                Type=Application
            '';
                # Type=XSession
            destination = "/share/xsessions/awesome-session.desktop";
            passthru = {
                providedSessions = [ "awesome-session" ];
            };
        })
    ];
  };

  security.pam.services.sddm = {
    fprintAuth = true;
  };

  security.pam.services.hyprlock.fprintAuth = false;

  services.xserver = {
    # dpi = 166;
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    wacom.enable = true;
    logFile = "/var/log/Xorg.0.log";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    package = pkgs-unstable.hyprland;
    systemd.setPath.enable = true;
    xwayland.enable = true;

    #enableNvidiaPatches = true;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      river = {
        binPath = "${pkgs-unstable.river}/bin/river";
        prettyName = "river";
        comment = "River Compositor";
        extraArgs = [];
      };
    };
  };

  # programs.river-classic = {
  #   enable = true;
  #   xwayland.enable = true;
  #   package = pkgs-unstable.river-classic;
  # };



}
