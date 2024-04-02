{ pkgs, lib, ... }: {
  programs.emacs = {
    enable = true;
    #defaultEditor = false;
  };
  services.emacs = {
    enable = true;
    # socketActivation.enable = true;
  };
}
