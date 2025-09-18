{ config, lib, pkgs, ...}: {
    imports = [
        ../../../modules/nixos/nix.nix
    ];
    wsl.enable = true;
    wsl.defaultUser = "trent";
    networking.hostName = "desktop-wsl";


    system.stateVersion = "25.05";
}
