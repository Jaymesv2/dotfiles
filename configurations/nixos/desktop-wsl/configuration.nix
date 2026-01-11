{ config, lib, pkgs, ...}: {
    imports = [
        ../../../modules/nixos/nix.nix
    ];
    wsl = {
        enable = true;
        defaultUser = "trent";
    };

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

    programs.zsh = {
        enable = true;
        interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";

    };

    environment.pathsToLink = [ "/share/zsh" ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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

    environment.systemPackages = with pkgs; [
      wget
      neovim
      wslu
    ];


    system.stateVersion = "25.05";
}
