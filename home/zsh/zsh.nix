{ lib, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
	"belak/zsh-utils path:editor"
	"belak/zsh-utils path:history"
	"belak/zsh-utils path:prompt"
	"belak/zsh-utils path:utility"
	"belak/zsh-utils path:completion"
	"ohmyzsh/ohmyzsh"
	"zsh-users/zsh-autosuggestions"
	"zsh-users/zsh-syntax-highlight"
	#"pkulev/zsh-rustup-completion"
	"sunlei/zsh-ssh"
	#"dbz/kube-aliases"


      ];

      # what does this do?
      #useFriendlyNames = true;

    };
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "git"
    #     "gpg-agent"
    #     "vi-mode"
    #   ];
    # };

    initExtra = ''
      zstyle ':completion:*' menu select
      setopt NO_EXTENDED_GLOB
    '';

    shellAliases = {
      "hm"   = "home-manager";
      "vim"  = "nvim";
      "vi"   = "nvim";
      "v"    = "nvim";
      "ls"   = "ls --color=auto";
      "l"    = "ls --color=auto";
      "df"   = "df -h";
      "du"   = "du -h -c";
      "cls"  = "clear";
      "step" = "step-cli";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "p10kConfig";
        src = ./p10k;
        file = "p10k.zsh";
      }
    ];

  };

  programs.direnv.enableZshIntegration = true;
  services.gpg-agent.enableZshIntegration = true;
  
}