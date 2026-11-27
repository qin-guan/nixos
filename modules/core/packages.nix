{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    unzip
    usbutils
    openssl
    nss.tools
    
    python3
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "qinguan" ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        floorp
        zen-beta
      '';
      mode = "0755";
    };
  };
}
