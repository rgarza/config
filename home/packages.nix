{ pkgs, pkgs-master, apple-silicon, ... }:
{
    home.packages = with pkgs; [    
      git
      fish
      binutils
      coreutils
      vim
      wget  
      nodejs-14_x
      openjdk
      maven
      flyctl
      postgresql_14
      docker
      docker-compose
      yarn
    ];
}