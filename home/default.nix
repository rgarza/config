{ config, pkgs, lib, ... }:
#let custompkgs = import /Users/rd/code/nixpkgs/default.nix {}; in
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
