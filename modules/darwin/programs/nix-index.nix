{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.programs.nix-index.enable {

    };
}