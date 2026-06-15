{ lib, pkgs, pkgs-unstable, ... }: let
    hyprland_target = "wayland-session@hyprland.desktop.target";
in {
    imports = [
        ../modules/home-manager/hyprland/hyprland.nix
    ];

    home.packages = [ pkgs.astral 
        # pkgs.phinger-cursors
    ];

    # wayland.windowManager.hyprland = {
    #     enable = true;
    # };
    # wayland.windowManager.hyprland.plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #   "/absolute/path/to/plugin.so"
    # ];

    # hyprctl setcursor phinger-cursors-dark 24
    home.pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
    };

    services.kdeconnect = {
        enable = true;
        indicator = true;
    };
    services.flameshot = {
        enable = true;
        # settings = {
        #     
        # };
    };

    services.hypridle = {
        # enable = true;
        # enable = true;
        systemdTarget = "wayland-session@Hyprland.target";
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch 'hl.dps.dpms({ action = \"enable\"})'";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
                # timeout = 30;
                timeout = 540;
                on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl set 30%" ;
                on-resume = "${pkgs.brightnessctl}/bin/brightnessctl set 100%";
            }
            {
              # timeout = 60;
              timeout = 600;
              on-timeout = "hyprlock";
            }
            {
              # timeout = 90;
              timeout = 660;
              on-timeout = "${pkgs-unstable.hyprland}/bin/hyprctl dispatch 'hl.dps.dpms({ action = \"disable\"})'";
              on-resume = "${pkgs-unstable.hyprland}/bin/hyprctl dispatch 'hl.dps.dpms({ action = \"enable\"})'";
            }
          ]; 
        };
    };
    
    # hyprpolkit
    # I only want it when running hyprland so i cant use the hm module
    systemd.user.services.hyprpolkitagent = {
      Unit = {
        Description = "Hyprland PolicyKit Agent";
        PartOf = [  hyprland_target ];
        After = [  hyprland_target ];
      };

      Install = {
        WantedBy = [  hyprland_target ];
      };

      Service = {
        ExecStart = "${pkgs-unstable.hyprpolkitagent}/libexec/hyprpolkitagent";
      };
    };

    services.mako = {
      enable = true;
      settings = {
        "actionable=true" = {
          anchor = "top-right";
        };
        actions = true;
        anchor = "top-right";
        background-color = "#000000";
        border-color = "#FFFFFF";
        border-radius = 0;
        default-timeout = 30000;
        font = "monospace 10";
        height = 100;
        icons = true;
        ignore-timeout = false;
        layer = "top";
        margin = 10;
        markup = true;
        width = 300;
      };
    };

    systemd.user.services.mako = {
      Unit = {
        Description = "mako notification daemon";
        PartOf    = [ hyprland_target];
        After     = [ hyprland_target];
        Requisite = [ hyprland_target] ;
      };
      Install.WantedBy = [hyprland_target];
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
        Restart = "on-failure";
        Slice = "session.slice";
      };
    };

    
    systemd.user.services.wayland-pipewire-idle-inhibit = let 
        settings = {
            media_minimum_duration = 5;
            idle_inhibitor = "wayland";
            # sink_whitelist = [
            #     { name = ""; }
            # ];
            # node_blacklist = [
            #     {name = "";}
            #     {app_name = "";}
            # ];
        };
        configFile = (pkgs.formats.toml {}).generate "wayland-pipewire-idle-inhibit.toml" settings;
    in {
        Unit = {
            Description = "wayland-pipewire-idle-inhibit";
            PartOf    = [ hyprland_target ];
            After     = [ "pipewire.service" hyprland_target ];
            Wants     = [ "pipewire.service" ];
        };
      Install.WantedBy = [ hyprland_target ];

      Service = {
        ExecStart = "${lib.getExe pkgs.wayland-pipewire-idle-inhibit} --config ${configFile}";
        Restart = "on-failure";
        RestartSec = 10;
      };
    };

    programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
          };

          animations = {
            enabled = true;
            fade_in = {
              duration = 300;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 300;
              bezier = "easeOutQuint";
            };
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];
          auth = {
            "fingerprint:enabled" = true;
            "fingerprint:ready_message" = "Scan fingerprint to unlock";
            "fingerprint:present_message" = "Scanning fingerprint";
          };

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              # monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              # placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
              shadow_passes = 2;
            }
          ];
        };       
    };


    programs.ashell = {
        enable = true;
        package = pkgs-unstable.ashell;
        systemd = {
            enable = true;
            target = hyprland_target;
        };
        settings = {
            outputs = "All";
            position = "Top";
            layer = "Top";

            modules = {
                left = ["Workspaces" "MediaPlayer" ];
                center = [ "WindowTitle" ];
                right = [ "SystemInfo" [ "Tray" ] [ "Tempo" "Settings" ] ];
                # right = [ "SystemInfo" "MediaPlayer"   [ "Tray" "Settings" ] ];
            };
            workspaces = {
                visibility_mode = "All";
                group_by_monitor = false;
                enable_workspace_filtering = "true";
            };
            window_title = {
                mode = "Title";
                truncate_title_after_length = 100;
            };
            tempo = {
                clock_format = "%a, %b %d %T";
                weather_location =  "Current";
                timezones = ["America/Chicago"];
            };
            system_info = {
                indicators = [ "Cpu" "Memory" "Temperature" ];
                # lower since memory is more important
                memory = {
                    warn_threshold = 60;
                    alert_threshold = 80;
                };
                cpu = {
                    warn_threshold = 70;
                    alert_threshold = 90;
                };
                temperature = {
                    warn_threshold = 60;
                    alert_threshold = 80;
                };
            };
            settings = {
                lock_cmd = "playerctl --all-players pause; hyprlock &";
                shutdown_cmd = "shutdown now";
                # suspend_cmd = "systemctl suspend";
                # hibernate_cmd = "systemctl hibernate";
                reboot_cmd = "reboot";
                logout_cmd = "uwsm stop";

            #     audio_sinks_more_cmd = "pavucontrol -t 3";
            #     audio_sources_more_cmd = "pavucontrol -t 4";
                wifi_more_cmd = "nm-connection-editor";
                vpn_more_cmd = "nm-connection-editor";
            #     bluetooth_more_cmd = "blueberry";
            #     battery_format = "IconAndPercentage";
            #     peripheral_battery_format = "Icon";
            #     audio_indicator_format = "Icon";
            #     microphone_indicator_format = "Icon";
            #     network_indicator_format = "Icon";
            #     bluetooth_indicator_format = "Icon";
            #     brightness_indicator_format = "Icon";
            #     indicators = [ "IdleInhibitor", "PowerProfile", "Audio", "Microphone", "Bluetooth", "Network", "Vpn", "Battery", "Brightness" ];
            };
            appearance = {
                style = "Islands";
                primary_color = "#7aa2f7";
                success_color = "#9ece6a";
                text_color = "#a9b1d6";
                workspace_colors = [ "#7aa2f7" "#9ece6a" ];
                special_workspace_colors = [ "#7aa2f7" "#9ece6a" ];
            };
        };
    };

    systemd.user.services."awww-daemon@hyprland" = {
      Unit = {
        Description = "Animated Background Daemon";

        PartOf    = [ hyprland_target  ];
        After     = [ hyprland_target  ];
        Requisite = [ hyprland_target  ];
        # ConditionEnvironment = "XDG_SESSION_TYPE=x11";
        # ConditionPathExists = "/tmp/.X11-unix/X0";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart="on-failure";
        Slice = "session.slice";
      };

      Install.WantedBy = [ hyprland_target ];
    };
}
