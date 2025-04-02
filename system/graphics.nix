{ pkgs, config, ... }: {
  services.xserver = {
    # dpi = 166;
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    wacom.enable = true;
    #logFile = "/dev/null";
    logFile = "/var/log/Xorg.0.log";

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;

        };
      };
      session = [
        {
          manage = "desktop";
          name = "xsession";
          start = ''exec $HOME/.xsession'';
        }
      ];
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #enableNvidiaPatches = true;
  };


}
