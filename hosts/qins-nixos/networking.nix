{ hostname, pkgs, ... }:

{
  networking.hostName = hostname;
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openconnect
    ];
    ensureProfiles.profiles.nus-student-vpn = {
      connection = {
        id = "NUS Student VPN";
        type = "vpn";
        autoconnect = false;
      };
      vpn = {
        service-type = "org.freedesktop.NetworkManager.openconnect";
        gateway = "8d0c.vpn.sse.cisco.com/NUSStudent";
        protocol = "anyconnect";
        useragent = "AnyConnect";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
  time.timeZone = "Asia/Singapore";
}
