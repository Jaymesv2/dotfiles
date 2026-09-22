{ nix-gaming, pkgs, lib, ... }: {
    imports = [
        ../../home/home.nix
        ../../home/ai.nix
        ../../home/river.nix
        ../../home/hyprland.nix
    ];
    home.packages = [
        nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
    ];
    services.hypridle.enable = false;
    #programs.discord.package = (pkgs.discord.override { commandLineArgs = "--ozone-platform=x11 --disable-features=UseOzonePlatform"; });

    # programs.discord.package = (pkgs.discord.overrideAttrs (old: rec {
    #     version = "1.0.155";
    #     commandLineArgs = "--ozone-platform=x11 --disable-features=UseOzonePlatform"; 
    #     src = pkgs.fetchurl {
    #       url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
    #       #hash = ""; # build once, paste the real hash
    #       hash="sha256-/CIT3gdp4aHjXC+iIszXPQP/BfPoBLnUE4QivIFvy6E=";
    #     };
    #   }));

}
