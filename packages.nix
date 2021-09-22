{ pkgs, ... }:
{
    home.packages = with pkgs; [    
      binutils
      coreutils
      vim
      wget  
      nodejs-14_x
      zsh-powerlevel10k
      jdk
      maven
      flyctl
      postgresql
    ];
}