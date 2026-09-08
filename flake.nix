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
      hostname = "qins-nixos";

      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

      # Base special args shared by all NixOS and home-manager modules.
      specialArgs = {
        inherit system username hostname pkgs-unstable;
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = [
          disko.nixosModules.disko
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager

          ./hosts/${hostname}
        ];
      };
    };
}
