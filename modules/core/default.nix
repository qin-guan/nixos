{ ... }:

{
  imports = [
    ./android.nix
    ./appimage.nix
    ./boot.nix
    ./ddc.nix
    ./tailscale.nix
    ./netbird.nix
    ./nixpkgs.nix
    ./packages.nix
    ./libreoffice.nix
    ./onlyoffice.nix
    ./plasma.nix
    ./flatpak.nix
    ./fonts.nix
    ./jetbrains.nix
    ./nix-ld.nix
    ./fcitx5.nix
    ./flox.nix
    ./virtualisation.nix
  ];

  environment.sessionVariables.SSL_CERT_FILE = "$HOME/.aspnet/dev-certs/trust/aspnetcore-localhost-3D4471165454D9DF7A4EC7F9779410322D1F6C80.pem";
}
