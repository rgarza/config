{ pkgs, pkgs-master, apple-silicon, ... }:
{
    home.packages = with pkgs; [
      git
      binutils
      coreutils
      awscli2
      bacon
      wget
      nodejs-18_x
      ffmpeg-full
      youtube-dl
      nodePackages.aws-cdk
      # awscli2
      nodePackages.typescript
      openjdk
      maven
      flyctl
      rust-analyzer
      gnugrep
      ripgrep
      postgresql_14
      docker
      docker-compose
      cocoapods
      tmux
      cargo
      rustc
      rustfmt
      fd
      go
      eza
    ];
}
