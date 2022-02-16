{ config, pkgs, lib, ... }:

{
  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = aarch64-darwin
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.shells = with pkgs; [   
    zsh
  ];
  programs.zsh.enable = true;

  system.stateVersion = 4;
}