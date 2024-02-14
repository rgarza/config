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

        bind '"' split-window -c "#{pane_current_path}"
        bind | split-window -h -c "#{pane_current_path}"

# ----- Messages -----
set-option -g mode-style 'bg=blue, fg=black'
set-option -g message-style 'bg=blue, fg=black'

# ----- Center -----
set-option -g status-justify centre
set-option -g status-style "bg=black"
set-window-option -g window-status-current-format '#[bold]#[fg=blue, bg=black]#[fg=black, bg=blue]#I:#W#[fg=blue, bg=black]'
set-window-option -g window-status-format '#I:#W'
set-window-option -g window-status-separator ' '
set-window-option -g window-status-style "bg=black"
set-window-option -g window-status-current-style "bg=blue,fg=black"


# ----- Left -----
set-option -g status-left " #S #[fg=blue, bg=black]"
set-option -g status-left-style "bg=blue,fg=black"


# ----- Right -----
set-option -g status-right "#[fg=blue, bg=black] #[fg=black, bg=blue] %d/%m  %R "
set-option -g status-right-style "bg=black,fg=blue"

        # tpm plugin
      '';
    };
}
