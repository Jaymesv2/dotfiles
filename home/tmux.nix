{ pkgs, lib, ...}: {
    programs.tmux = {
        enable = true;
        escapeTime = 500;
        mouse = true;
    };
}
