{ pkgs, pkgs-master, apple-silicon, ... }:
{
    home.packages = with pkgs; [    
      git
      fish
      binutils
      hugo
      coreutils
      vim
      wget  
      nodejs-18_x
      ffmpeg-full
      nodePackages.aws-cdk
      awscli2
      nodePackages.typescript
      openjdk
      maven
      flyctl
      postgresql_14
      docker
      docker-compose
      yarn
      cocoapods
      wrangler
      tmux
    ];
}