{ pkgs, config, ...}: {
    services.avahi = {
        enable = true;
        nssmdns = true;  # Allows .local name resolution
        openFirewall = true;
    };

    services.printing.drivers = [ pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];
}
