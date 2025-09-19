{ config, lib, pkgs, ...}: {
    imports = [
        ../../../modules/nixos/nix.nix
    ];
    wsl.enable = true;
    wsl.defaultUser = "trent";
    networking.hostName = "desktop-wsl";

    users.groups.trent = {};
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.trent = {
      isNormalUser = true;
      description = "Trent";
      group = "trent";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
      # packages = with pkgs; [];
      # initialPassword = "123abc"; # best password
    };


    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      # (nerdfonts.override { } )
    ];


    system.stateVersion = "25.05";
}
