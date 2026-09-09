{ ... }:

{
  imports = [
    ./nixpkgs.nix
    ./packages.nix
    ./plasma.nix
    ./flatpak.nix
    ./fonts.nix
    ./nix-ld.nix
    ./fcitx5.nix
    ./virtualisation.nix
  ];
}
