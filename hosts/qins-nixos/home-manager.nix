{ system, username, hostname, pkgs-unstable, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit system username hostname pkgs-unstable;
    };
    users.${username} = import ../../modules/home;
  };
}
