{ lib, pkgs, ... }: {
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
}