{ config, pkgs, lib, ... }:
{
    imports = [
      ./packages.nix
      ./configs/git/git.nix
      ./zsh.nix
      ./fish.nix
      ./alacritty.nix
      ./fzf.nix
    ];

    programs.bat.enable = true;
    programs.bat.config = {
      style = "plain";
    };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    programs.nix-index.enable = true;

    programs.home-manager = {
      enable = true;
    };
}
