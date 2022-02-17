{ pkgs, apple-silicon, ... }:
{
    home.packages = with pkgs; [    
      git
      fish
      kitty
      binutils
      coreutils
      vim
      wget  
      nodejs-14_x
      jdk
      maven
      flyctl
      postgresql_14
      docker
      docker-compose
    ];
}