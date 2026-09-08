# NixOS Configuration

This repository contains the NixOS and Home Manager configuration for `qins-nixos`.

Packages normally come from stable `nixpkgs`. Packages from `nixos-unstable` are available as `pkgs.unstable`:

```nix
environment.systemPackages = [ pkgs.unstable.some-package ];
```

The unstable package set uses the same `allowUnfree` setting as stable packages. This is configured in `modules/core/nixpkgs.nix`.

Home Manager modules are in `modules/home/`, with one file per program where practical.

## Configuration Flow

```mermaid
flowchart TD
  Inputs[flake inputs<br/>nixpkgs, nixpkgs-unstable,<br/>home-manager, disko, plasma-manager] --> Flake[flake.nix]
  Flake --> System[nixosSystem<br/>qins-nixos]
  Flake --> Args[specialArgs<br/>system, username, hostname,<br/>nixpkgs-unstable]
  Flake --> External[External modules<br/>disko, nix-flatpak,<br/>home-manager, plasma-manager]
  Flake --> ExtOverlay[nix-vscode-extensions overlay]

  System --> Host[hosts/qins-nixos/default.nix]
  Args --> CoreNixpkgs[modules/core/nixpkgs.nix]
  External --> Host
  ExtOverlay --> Stable[pkgs<br/>stable nixpkgs]

  Host --> HostModules[boot, networking, packages,<br/>services, users, disko]
  Host --> Core[modules/core/default.nix]
  Host --> Drivers[modules/drivers/nvidia-laptop.nix]
  Core --> CoreNixpkgs
  Core --> CoreModules[plasma, flatpak, fonts,<br/>fcitx5, virtualisation]

  CoreNixpkgs --> Stable
  CoreNixpkgs --> Unstable[pkgs.unstable<br/>nixos-unstable with<br/>stable nixpkgs config]

  Host --> HMBridge[hosts/qins-nixos/home-manager.nix]
  External --> HMBridge
  Stable --> HM[Home Manager<br/>useGlobalPkgs = true]
  HMBridge --> HM
  HM --> Home[modules/home/default.nix]
  Home --> Programs[Per-program modules<br/>bash, git, vscode, opencode, ...]
  Stable --> Programs
  Unstable --> Programs
```
