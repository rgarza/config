{ config, lib, pkgs, ... }:
{
    environment.shellInit =  ''
        eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';
    # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
    # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
    # seem to work, but they do work if added at the start.
    programs.fish.interactiveShellInit =  ''
        if test -d (brew --prefix)"/share/fish/completions"
            set -p fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)"/share/fish/vendor_completions.d"
            set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
    '';

    homebrew.taps = [
        "homebrew/cask"
        "homebrew/cask-drivers"
        "homebrew/cask-fonts"
    ];
    homebrew.enable = true;
    homebrew.onActivation.autoUpdate = true;
    homebrew.onActivation.upgrade = true;
    homebrew.onActivation.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.masApps = {
        "BitWarden" = 1352778147;
        "Wireguard" = 1451685025;
    };
    homebrew.casks = [
        "secretive"
        "vlc"
        "transmission"
        "insomnia"
        "iterm2"
        "github"
        "font-jetbrains-mono-nerd-font"
    ];

    environment.variables.SSH_AUTH_SOCK = "/Users/${config.users.primaryUser.username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

}