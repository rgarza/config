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


# TokyoNight colors for Tmux

set -g mode-style "fg=#7aa2f7,bg=#3b4261"

set -g message-style "fg=#7aa2f7,bg=#3b4261"
set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#7aa2f7"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#7aa2f7,bg=#16161e"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
  set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
}

setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
setw -g window-status-format "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#16161e,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#16161e]#[fg=#16161e]#[bg=#e0af68]"
set -g @prefix_highlight_output_suffix ""


        # tpm plugin
      '';
    };
}
