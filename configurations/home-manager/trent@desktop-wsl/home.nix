{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: rec {
  imports = [
    ../../../modules/home-manager/nvim/nvim.nix
  ];



  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
