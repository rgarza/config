{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };
    autosuggestion = {
        enable = true;
    };
    enableCompletion = false;

    initExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      .  '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      export PATH=$PATH:/run/current-system/sw/bin/

      export SSH_AUTH_SOCK=/Users/rd/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh


    '';
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
    };
    prezto = {
      enable = true;
      # prompt = {
      #   theme = "powerline";
      # };
      pmodules = [
        "directory"
        "utility"
        "completion"
        "git"
        "tmux"
        # "prompt"
        "syntax-highlighting"
        "history-substring-search"
      ];
      tmux = {
        autoStartLocal = true;
        itermIntegration = true;

      };
      extraConfig = ''
        zstyle ':completion:*:*:*:*:*' menu select

      '';
    };

    # plugins = [
    #     {
    #       name = "powerlevel10k";
    #       src = pkgs.zsh-powerlevel10k;
    #       file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #     }
    #     {
    #       name = "powerlevel10k-config";
    #       src = lib.cleanSource ../configs/zsh/p10k.zsh;
    #       file = "";
    #     }
    #   ];
  };

}
