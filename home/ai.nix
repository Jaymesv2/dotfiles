{ lib, pkgs, pkgs-unstable, options, config, ... }: {
    # services.local-ai = {
    #     enable = true;
    #     environment = {};
    # };
    home.packages = with pkgs-unstable; [
        claude-code
    ];
}
