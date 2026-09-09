{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-CT1000P5PSSD8_22343AC8EA41";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
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
            settings = {
              allowDiscards = true;
            };
            content = {
              type = "btrfs";
              extraArgs = [ "-f" "-L" "nixos" ];
              subvolumes = {
                "@root" = { mountpoint = "/";    mountOptions = [ "compress=zstd" "noatime" ]; };
                "@home" = { mountpoint = "/home";  mountOptions = [ "compress=zstd" "noatime" ]; };
                "@nix"  = { mountpoint = "/nix";  mountOptions = [ "compress=zstd" "noatime" ]; };
                "@swap" = { mountpoint = "/.swapvol";  swap.swapfile.size = "32G";};
              };
            };
          };
        };
      };
    };
  };

        disko.devices.disk.sandisk = {
                type = "disk";
                device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_1T00_21503H801441";
                content = {
                        type = "gpt";
                        partitions = {
                                data = {
                                        size = "100%";
                                        content = {
                                                type = "btrfs";
                                                extraArgs = [ "-L" "SanDisk" ];
                                                subvolumes = {
                                                        "@data" = {
                                                                mountpoint = "/mnt/SanDisk";
                                                                mountOptions = [
                                                                        "compress=zstd"
                                                                        "noatime"
                                                                        "nofail"
                                                                        "x-systemd.device-timeout=10s"
                                                                ];
                                                        };
                                                };
                                        };
                                };
                        };
                };
        };
}
