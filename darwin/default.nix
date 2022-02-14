{ pkgs, lib, ... }:

{
#   imports = [
#     # Minimal config of Nix related options and shells
#     ./bootstrap.nix

#     # Other nix-darwin configuration
#     ./homebrew.nix
#     ./defaults.nix
#   ];

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
  ];
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}