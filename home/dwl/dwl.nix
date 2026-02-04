{ pkgs, lib, ... }: {
    home.packages = with pkgs; [
        dwl
    ];
}
