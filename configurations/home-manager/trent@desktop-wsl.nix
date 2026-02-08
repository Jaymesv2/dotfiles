{ lib, pkgs, pkgs-unstable, nix-gaming, ... }: rec {
  imports = [
    ../../modules/home-manager/nvim/nvim.nix
    ../../modules/home-manager/zsh/zsh.nix
  ];



  home = {
    username = "trent";
    homeDirectory = "/home/trent";
    stateVersion = "25.05";
  };

  programs.git = {
    enable = true;
    userEmail = "ghastfilms613@gmail.com";
    userName = "Trent";
  };

  programs.home-manager.enable = true;
}
