{ config, lib, pkgs, ... }:

let
in
{
    programs.tmux = {
      enable = true;
      
      keyMode = "vi";
      escapeTime = 10;
      newSession = true;
      extraConfig = ''
        set -g default-terminal "screen-256color"

        set -g prefix C-a
        unbind C-b
        bind-key C-a send-prefix

        unbind %
        bind | split-window -h 

        unbind '"'
        bind - split-window -v

        unbind r
        bind r source-file ~/.tmux.conf

        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5
        bind -r h resize-pane -L 5

        bind -r m resize-pane -Z

        set -g mouse on

        set-window-option -g mode-keys vi

        bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
        bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

        unbind -T copy-mode-vi MouseDragEnd1Pane # don't exit copy mode when dragging with mouse

        # remove delay for exiting insert mode with ESC in Neovim
        set -sg escape-time 10

        # tpm plugin
      '';
    };
}