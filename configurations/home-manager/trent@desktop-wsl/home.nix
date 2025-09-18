{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: rec {
  imports = [
  ];



  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
