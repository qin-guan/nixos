{
  description = "Qin Guan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs = 
  {
    nixpkgs,
    nixpkgs-unstable,
    disko,
    home-manager,
    nix-flatpak,
    ...
  }: 
  let 
    system = "x86_64-linux";
    username = "qinguan";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.qins-nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit username;
      };

      modules = [
        disko.nixosModules.disko
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager

        ./hosts/qins-nixos

	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { inherit username; inherit pkgs-unstable; };

	  home-manager.users.${username} = import ./home/qinguan.nix;
	}
      ];
    };
  };
}
