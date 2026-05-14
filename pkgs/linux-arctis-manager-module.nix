{ config, options, lib, pkgs, ... }: let
  cfg = config.services.linux-arctis-manager;
  # Pick the package built for this system.
  # pkg = pkgs.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.services.linux-arctis-manager = {
    enable = lib.mkEnableOption "Linux Arctis Manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.linux-arctis-manager;
      defaultText = lib.literalExpression "linux-arctis-manager.packages.\${system}.default";
      description = "The Linux Arctis Manager package to use.";
    };

    installDesktopEntries = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install ArctisManager and ArctisManagerSystray desktop entries.";
    };

    installSystemdUserUnit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Install the arctis-manager.service systemd user unit. Users can
        enable it with `systemctl --user enable --now arctis-manager.service`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # udev rules expose the Arctis HID/USB devices to the user session.
    services.udev.packages = [ cfg.package ];

    # Desktop entries shipped by the package.
    environment.pathsToLink = lib.optionals cfg.installDesktopEntries [
      "/share/applications"
      "/share/icons"
    ];

    # Systemd user unit, optionally exposed to all users.
    systemd.user.services.arctis-manager = lib.mkIf cfg.installSystemdUserUnit {
      description = "Arctis Manager";
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 5;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/lam-daemon";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
