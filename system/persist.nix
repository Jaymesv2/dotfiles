{ lib, options, config, ... }: {

  environment.etc."nixos".source = "/home/trent/.config/nix";
  fileSystems."/persistent".neededForBoot = true;

  environment.persistence."/persistent" = {
    enable = true;  # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      # "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      { directory = "/var/lib/docker"; user = "root"; group = "root"; mode="u=rwx,g=x,o="; }
      { directory = "/var/lib/fprintd"; user = "root"; group = "root"; mode = "u=rwx,g=,o="; }
      { directory = "/var/lib/fprint"; user = "root"; group = "root"; mode = "u=rwx,g=,o="; }
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"

      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      #{ file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    # users.bird = {
    #   directories = [
    #     "Downloads"
    #     "Music"
    #     "Pictures"
    #     "Documents"
    #     "Videos"
    #     "VirtualBox VMs"
    #     { directory = ".gnupg"; mode = "0700"; }
    #     { directory = ".ssh"; mode = "0700"; }
    #     { directory = ".nixops"; mode = "0700"; }
    #     { directory = ".local/share/keyrings"; mode = "0700"; }
    #     ".local/share/direnv"
    #   ];
    #   files = [
    #     ".screenrc"
    #   ];
    # };
  };


  # boot.initrd.postResumeCommands = lib.mkAfter ''
  # '';


}
