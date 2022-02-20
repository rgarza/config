{ config, pkgs, lib, ... }:
{
    imports = [
      ./packages.nix
      ./configs/git/git.nix
      ./shells.nix
    ];

    programs.bat.enable = true;
    programs.bat.config = {
      style = "plain";
    };
    # See `./shells.nix` for more on how this is used.
    programs.fish.functions.set-bat-colors = {
      body = ''set -xg BAT_THEME "Solarized ($term_background)"'';
      onVariable = "term_background";
    };
    programs.fish.interactiveShellInit = ''
      # Set `bat` colors based on value of `$term_backdround` when shell starts up.
      set-bat-colors
    '';
    
   
    programs.nix-index.enable = true;

    programs.home-manager = {
      enable = true;
    };
}
