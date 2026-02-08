{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANS0NA24539B";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            crypt0 = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt0";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings = {
                  allowDiscards = true;
                };
                # content = {
                #   type = "btrfs";
                # };
              };
            };
          };
        };
      };

      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686A73CF5";
        content = {
          type = "gpt";
          partitions = {
            crypt1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt1";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";

                  extraArgs = [ "-f" "-L" "nixos" "-d raid0" "-m raid0" "/dev/mapper/crypt0"];

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
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ]; 
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" "ssd" "discard=async" ];
                    };
                    # "/swap" = {
                    #   mountpoint = "/.swapvol";
                    #   mountOptions = [ "nodatacow" ];
                    #   swap.swapfile.size = "70G";
                    # };
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
