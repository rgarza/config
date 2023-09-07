{ pkgs, pkgs-master, apple-silicon, ... }:
{
    home.packages = with pkgs; [    
      git
      binutils
      coreutils
      wget  
      nodejs-18_x
      ffmpeg-full
      nodePackages.aws-cdk
      awscli2
      nodePackages.typescript
      openjdk
      maven
      flyctl
      ripgrep
      postgresql_14
      docker
      docker-compose
      cocoapods
      tmux
    ];
}