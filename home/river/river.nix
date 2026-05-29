{ config, options, pkgs, pkgs-unstable, ... }: let
    inherit (lib) types;
    cfg = config.wayland.windowManager.river-new;

in {
    options.wayland.windowManager.river-new = {
        enable = lib.mkEnableOption "Enable new river";
        systemd = {
            enable = lib.mkEnableOption null // {
                default = true;
            };

        };
        package = lib.mkPackageOption pkgs-unstable "river" {
            nullable = true;
            extraDescription = ''

            '';
        }
    };

    config = lib.mkIf cfg.enable {
        assertions = [
            ()
        ];
        # home.packages

        xdg.configFile."river/init".source = pkgs.writeShellScript "init" (
            ''

            ''
            # + (lib.optionalString )
        );
    };

    # wayland.windowManager.river = {
    #     enable = true;
    #     extraConfig = ;
    #     systemd = {
    #
    #     };
    #     settings = {
    #
    #     };
    # };
}
