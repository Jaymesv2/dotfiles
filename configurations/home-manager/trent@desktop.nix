{ nix-gaming, pkgs, ... }: {
    imports = [
        ../../home/home.nix
        ../../home/ai.nix
        ../../home/river.nix
        ../../home/hyprland.nix
    ];
    home.packages = [
        nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
    ];

}
