{ inputs, system, username, hostname, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs system username hostname;
    };
    users.${username} = import ../../modules/home;
  };
}
