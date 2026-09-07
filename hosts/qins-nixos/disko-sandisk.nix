{
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
