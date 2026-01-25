{ pkgs, lib, ... }: {
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
  
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  
  environment.persistence."/persistent" = { directories = [ "/var/lib/sbctl" ]; };
  boot.lanzaboote = {
    enable = true;
    autoGenerateKeys.enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoEnrollKeys = {
      enable = true;
      # Automatically reboot to enroll the keys in the firmware
      autoReboot = true;
     };
  };
}
