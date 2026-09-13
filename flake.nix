{
  description = "Qin Guan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      disko,
      home-manager,
      microvm,
      plasma-manager,
      nix-flatpak,
      nix-vscode-extensions,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "qinguan";
      hostname = "qins-nixos";

      # Arguments shared by NixOS modules.
      specialArgs = {
        inherit
          system
          username
          hostname
          nixpkgs-unstable
          home-manager
          ;
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules = [
          disko.nixosModules.disko
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          microvm.nixosModules.host
          {
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
          }
          {
            nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
          }

          ./hosts/${hostname}
        ];
      };
    };
}
