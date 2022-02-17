{ config, pkgs, lib, ... }:

{

   nix.binaryCaches = [
    "https://cache.nixos.org/"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;

  environment.shells = with pkgs; [   
    fish
  ];
  
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    export SSH_AUTH_SOCK=/Users/rd/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh	
    export PATH=/var/run/current-system/sw/bin/:$HOME/.nix-profile/bin:$PATH:/usr/local/bin

    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  system.stateVersion = 4;
}