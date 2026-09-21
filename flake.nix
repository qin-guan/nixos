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

    llm-agents = {
      url = "github:qin-guan/llm-agents.nix/?ref=patch-1";
    };
    
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    
    mise = {
      url = "github:jdx/mise";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      disko,
      home-manager,
      plasma-manager,
      nix-flatpak,
      nix-vscode-extensions,
      llm-agents,
      ghostty,
      mise,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "qinguan";
      hostname = "qins-nixos";

      # Arguments shared by NixOS modules.
      specialArgs = {
        inherit
          inputs
          system
          username
          hostname
          nixpkgs-unstable
          home-manager
          llm-agents
          ghostty
          mise
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

          {
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
          }

          {
            nixpkgs.overlays = [ 
              nix-vscode-extensions.overlays.default
              mise.overlays.default
            ];
          }

          ./hosts/${hostname}
        ];
      };
    };
}
