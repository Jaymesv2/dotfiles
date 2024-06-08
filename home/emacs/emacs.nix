{ pkgs, lib, ... }: {
  programs.emacs = {
    enable = true;
    extraConfig = ''
      ;; Enable Evil
      (require 'evil)
      (evil-mode 1)
    '';
    extraPackages = epkgs: with epkgs; [ evil ];
    #defaultEditor = false;
  };
  services.emacs = {
    enable = true;
    # socketActivation.enable = true;
  };
}
