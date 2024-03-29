{ config, pkgs, lib, ... }:
{
 

  nix.configureBuildUsers = true;

  nix.settings = {

    substituters = [
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [ "@admin" ];

    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];
    keep-outputs = true;
    keep-derivations = true;

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
    
  };

  nix.package = pkgs.nixUnstable;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;


  environment.shells = with pkgs; [   
    zsh
  ];

  system.stateVersion = 4;
}