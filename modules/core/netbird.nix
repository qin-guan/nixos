{ pkgs, ... }:
{
  services.netbird = {
    enable = true;
    package = pkgs.unstable.netbird;
    ui = {
      enable = true;
      package = pkgs.unstable.netbird-ui;
    }
  };
}
