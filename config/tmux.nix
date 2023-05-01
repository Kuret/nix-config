{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    mouse = true;
    clock24 = true;
    historyLimit = 9999;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    sensibleOnTop = false;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Window splits
      bind \\ split-window -h
      bind - split-window -v

      # Window navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Kill pane / window
      bind x kill-pane
      bind X kill-window

      # Reload config
      bind R source-file ~/tmux/tmux.conf

      # Automatically set window title
      set -g automatic-rename on
      set -g set-titles on

      # Status style
      set -g status-style bg=cyan,fg=black
      set -g window-status-current-style bg=black,fg=cyan

      set -g status-left ""
      set -g status-right " %d %b   %H:%M "
      set -g window-status-format " #I: #W "
      set -g window-status-current-format " #I: #W "
    '';
  };
}
