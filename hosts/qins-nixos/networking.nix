{ hostname, ... }:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Singapore";
}
