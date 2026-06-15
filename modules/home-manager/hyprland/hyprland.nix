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

  home.file.hyprlandImport = let 
    myPlugins = with pkgs-unstable.hyprlandPlugins; [ /*hyprspace*/ ];
  loadLines = lib.concatMapStringsSep "\n"
    (p: ''hl.exec_cmd("hyprctl plugin load ${p}/lib/lib${p.pname}.so")'')
    # nixpkgs builds these as lib<name>.so — verify the exact filename below
    myPlugins;
  in {
    enable = true;
    recursive = true;
    target = ".config/hypr/hyprland.lua";
    text = ''
        -- Load plugins
        -- hl.on("hyprland.start", function()
        --     ${loadLines}
        -- end)
        require('hyprland.hyprland')
    '';
  };
}
