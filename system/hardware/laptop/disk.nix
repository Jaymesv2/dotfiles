{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # device = "/dev/nvme0n1";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7KHNJ0WB35025A";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  # keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  # name the volume
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    # persistent data
                    "/persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ];
                    };
                    # root volume which is reset every boot
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ];
                    };
                    # 
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ]; };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ];
                    };
                    "/log" = {
                      mountpoint = "/log";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ];
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      mountOptions = [ "nodatacow" ];
                      swap.swapfile.size = "70G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
