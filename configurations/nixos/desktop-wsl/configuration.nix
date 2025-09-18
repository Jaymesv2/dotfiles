{ config, lib, pkgs, ...}: {
    imports = [
        # nixoswsl
    ];
    wsl.enable = true;
    wsl.defaultUser = "trent";
    networking.hostName = "desktop-wsl";


    system.stateVersion = "25.05";
}
