{ ... }: {
    imports = [
        ../../home/home.nix
        ../../home/river.nix
        ../../home/hyprland.nix
    ];

    services.hypridle.enable = true;
}
