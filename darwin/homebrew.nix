{ config, lib, pkgs, ... }:
{
    environment.shellInit =  ''
        eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';
    #homebrew.taps = [
    #    "homebrew/cask"
    #    "homebrew/cask-drivers"
    #    "homebrew/cask-fonts"
    #];
    homebrew.enable = true;
    # homebrew.onActivation.autoUpdate = true;
    # homebrew.onActivation.upgrade = true;
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
        "font-hack-nerd-font"
    ];

    environment.variables.SSH_AUTH_SOCK = "/Users/${config.users.primaryUser.username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

}
