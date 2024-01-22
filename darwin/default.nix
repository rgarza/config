{ pkgs, lib, ... }:

{
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  imports = [
    ./bootstrap.nix
    ./homebrew.nix
  ];


  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];
}
