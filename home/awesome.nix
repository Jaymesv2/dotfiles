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

  home.packages = with pkgs; [ xsecurelock picom nitrogen xscreensaver ];

  services.screen-locker = {
    enable = true;
    xautolock.enable = false;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    lockCmdEnv = [
      # "XSECURELOCK_PAM_SERVICE=xsecurelock"
      "XSECURELOCK_BLANK_TIMEOUT=-1"
      "XSECURELOCK_SAVER=saver_xscreensaver"
      # "XSECURELOCK_DISCARD_FIRST_KEYPRESS=1"
    ];
  };
}
