{ options, config, lib, ... }: with lib; let
    cfg = config.boot.impermanence;
in {
    options.boot.impermanence = {
        enable = mkEnableOption "Enable Impermanence";
        root_name = mkOption {
            type = types.str;
            default = "root";
        };
        luks_name = mkOption {
            type = types.str;
            default = "cryptroot";
        };
    };
    config = mkIf cfg.enable {

      boot.initrd.systemd.enable = true;

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

        script = ''
          echo "impermanence: starting btrfs cleanup"
          mkdir /btrfs_tmp
          echo "impermanence: mounting ${cfg.luks_name} to /btrfs_tmp"
          if [[ ! -e /dev/mapper/${cfg.luks_name} ]]; then
            echo "/dev/mapper/${cfg.luks_name} was not found"
          fi

          mount /dev/mapper/${cfg.luks_name} /btrfs_tmp
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
    };
}
