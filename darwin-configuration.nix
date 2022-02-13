{ config, pkgs, lib, ... }:
#let custompkgs = import /Users/rd/code/nixpkgs/default.nix {}; in
{
  
  imports = [ <home-manager/nix-darwin> ];
  environment.systemPackages = with pkgs; [ ];
  home-manager.useUserPackages = false;
  environment.darwinConfig = "$HOME/.nixpkgs/darwin-configuration.nix";
  services.nix-daemon.enable = true;
  home-manager.useGlobalPkgs = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
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
