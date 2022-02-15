{ config, pkgs, lib, ... }:
{
    imports = [
      ./packages.nix
      ./configs/zsh/zsh.nix
      ./configs/git/git.nix
    ];
    programs.home-manager = {
      enable = true;
    };

    home.sessionVariables = {
      NIX_PATH = "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels";
    };        
  
}
