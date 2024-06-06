{ lib, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 8.0;
      # "font.normal".family = "MesloLGS NF";
      window = {
        decorations = "full";
        decorations_theme_variant = "Dark";
        dynamic_padding = false;
        dynamic_title = true;
        opacity = 0.7;
      };
    };
  };
}
