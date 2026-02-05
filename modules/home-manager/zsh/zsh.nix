{ lib, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    # what does this do?
    #useFriendlyNames = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      zstyle ':completion:*' menu select
      setopt NO_EXTENDED_GLOB
      # bindkey -M menuselect '\r' .accept-line
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

      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
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
      {
        name = "autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      # {
      #   name = "autocomplete";
      #   src = pkgs.zsh-autocomplete;
      #   file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      # }
      # {
      #   name = "zsh-vi-mode";
      #   src = pkgs.zsh-vi-mode;
      #   file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      # }

      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "nix-shell.plugin.zsh";
      }

 #        "jeffreytse/zsh-vi-mode"
	# "belak/zsh-utils path:editor"
	# "belak/zsh-utils path:history"
	# "belak/zsh-utils path:prompt"
	# "belak/zsh-utils path:utility"
	# "belak/zsh-utils path:completion"
	# "ohmyzsh/ohmyzsh"
	# "zsh-users/zsh-autosuggestions"
	# "zsh-users/zsh-syntax-highlight"
	# #"pkulev/zsh-rustup-completion"
	# "sunlei/zsh-ssh"
	# #"dbz/kube-aliases"
    ];

  };

  programs.direnv.enableZshIntegration = true;
  services.gpg-agent.enableZshIntegration = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {};
  };

  programs.nix-index = {
    enable = true;
    symlinkToCacheHome = true;
  };
  programs.nix-index-database.comma.enable = true;


}
