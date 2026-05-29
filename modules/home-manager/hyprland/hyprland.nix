{lib, pkgs, pkgs-unstable, options, ... }: {
  workingFiles.enable = true;

  # because of the way this is setup all of the hyprland imports have to prefix `hyprland.` in the module name
  workingFiles.file.hyprlandConfig.linkSource = ".config/nix/modules/home-manager/hyprland";
  # 
  home.file.hyprlandConfig = {
      enable = true;
      source = ./.;
      recursive = true;
      target = ".config/hypr/hyprland";
  };

  home.file.hyprlandImport = {
    enable = true;
    recursive = true;
    target = ".config/hypr/hyprland.lua";
    text = ''
        require('hyprland.hyprland')
    '';
  };
}
