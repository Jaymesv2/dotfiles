{ lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "ghastfilms613@gmail.com";
    userName = "Trent";
    # signing = {
    #   signByDefault = true;
    #   key = "";
    #   gpgPath = "";
    # };
  };
  programs.gitui.enable = true;
}
