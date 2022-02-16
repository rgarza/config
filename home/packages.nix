{ pkgs, ... }:
{
    home.packages = with pkgs; [    
      pkgs-unstable.git
      binutils
      coreutils
      vim
      wget  
      nodejs-14_x
      zsh-powerlevel10k
      jdk
      maven
      flyctl
      postgresql_14
      docker
      docker-compose
    ];
}