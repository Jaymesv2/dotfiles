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

  boot.initrd.systemd.services.recreate-root = {
    description = "Rolling over and creating new filesystem root";

    wantedBy = [ "initrd.target" ];
    requires = [ "initrd-root-device.target" ];
    after = [
      "initrd-root-device.target"
      "local-fs-pre.target"
    ];
    before = [
      "sysroot.mount"
      "create-needed-for-boot-dirs.service"
    ];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    script = let 
        root_name = "root";
        luks_name = "cryptroot";
    in ''
      echo "impermanence: starting btrfs cleanup"
      mkdir /btrfs_tmp
      echo "impermanence: mounting ${luks_name} to /btrfs_tmp"
      if [[ ! -e /dev/mapper/${luks_name} ]]; then
        echo "/dev/mapper/${luks_name} was not found"
      fi

      mount /dev/mapper/${luks_name} /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          echo "impermanence: moving current root to old roots"
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          echo "impermanence: recursively deleting old root $i"
          delete_subvolume_recursively "$i"
      done

      echo "impermanence: creating new root volume"
      btrfs subvolume create /btrfs_tmp/root
      echo "impermanence: unmounting /btrfs_tmp"
      umount /btrfs_tmp

    '';
  };

  # boot.initrd.postResumeCommands = lib.mkAfter ''
  # '';


}
