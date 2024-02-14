{ home, pkgs, ... }: {
    home.file.".alacritty.toml" = {
        source = ../configs/alacritty/.alacritty.toml;
    };
}
