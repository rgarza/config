{ pkgs, lib, ... }:

{
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  imports = [
    ./bootstrap.nix
  ];


  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}