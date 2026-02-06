{ lib, pkgs, options, config, ... }: {
  programs.git = {
    enable = true;
    settings.user = {
        email = "ghastfilms613@gmail.com";
        name = "Trent";
    };
    # signing = {
    #   signByDefault = true;
    #   key = "";
    #   gpgPath = "";
    # };
    includes = [{
        condition = "gitdir:~/Documents/classes/";
        path = "${config.sops.secrets."university.gitconfig".path}";
    }];

  };
  sops.secrets."university.gitconfig" = {
          sopsFile = ./git/university.sops.gitconfig;
          format = "binary";
        };
  programs.gitui.enable = true;

  # sops = {
  #
  #
  # };

  # sops.templates."university.gitconfig".content = ''
  #   password = "''${config.sops.placeholder.your-secret}"
  # '';
}
