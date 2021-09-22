{ config, pkgs, lib, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  environment.systemPackages = with pkgs; [ ];
  home-manager.useUserPackages = false;
  environment.darwinConfig = "$HOME/.nixpkgs/darwin-configuration.nix";

  home-manager.useGlobalPkgs = true;
  users.users.rd = {
    name = "rd";
    home = "/Users/rd";
  };

  home-manager.users.rd = { pkgs, ... }: {
    
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
  }; 
 
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
