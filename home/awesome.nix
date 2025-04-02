{ pkgs, lib, config, ... }: {

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
}
