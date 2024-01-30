 { config, pkgs, lib, ... }:

 {
   # Fish Shell
   # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
   programs.fish.enable = true;

   programs.fish.functions = {
     # Toggles `$term_background` between "light" and "dark". Other Fish functions trigger when this
     # variable changes. We use a universal variable so that all instances of Fish have the same
     # value for the variable.
     toggle-background.body = ''
       if test "$term_background" = light
         set -U term_background dark
       else
         set -U term_background light
       end
     '';

     # Set `$term_background` based on whether macOS is light or dark mode. Other Fish functions
     # trigger when this variable changes. We use a universal variable so that all instances of Fish
     # have the same value for the variable.
     set-background-to-macOS.body = ''
       # Returns 'Dark' if in dark mode fails otherwise.
       if defaults read -g AppleInterfaceStyle &>/dev/null
         set -U term_background dark
       else
         set -U term_background light
       end
     '';

     # Sets Fish Shell to light or dark colorscheme based on `$term_background`.
     set-shell-colors = {
       body = ''
         # Use correct theme for `btm`
         #if test "$term_background" = light
         #  alias btm "btm --color default-light"
         #else
         #  alias btm "btm --color default"
         #end
         # Set LS_COLORS
         #set -xg LS_COLORS (${pkgs.vivid}/bin/vivid generate solarized-$term_background)
         # Set color variables
        # if test "$term_background" = light
         #  set emphasized_text  brgreen  # base01
         #  set normal_text      bryellow # base00
         #  set secondary_text   brcyan   # base1
         #  set background_light white    # base2
         #  set background       brwhite  # base3
         #else
         #  set emphasized_text  brcyan   # base1
         #  set normal_text      brblue   # base0
         #  set secondary_text   brgreen  # base01
         #  set background_light black    # base02
         #  set background       brblack  # base03
         #end
         # Set Fish colors that change when background changes
         #set -g fish_color_command                    $emphasized_text --bold  # color of commands
         #set -g fish_color_param                      $normal_text             # color of regular command parameters
         #set -g fish_color_comment                    $secondary_text          # color of comments
         #set -g fish_color_autosuggestion             $secondary_text          # color of autosuggestions
         #set -g fish_pager_color_prefix               $emphasized_text --bold  # color of the pager prefix string
         #set -g fish_pager_color_description          $selection_text          # color of the completion description
         #set -g fish_pager_color_selected_prefix      $background
         #set -g fish_pager_color_selected_completion  $background
         #set -g fish_pager_color_selected_description $background


             # TokyoNight

    # Syntax Highlighting Colors
    set -g fish_color_normal c0caf5
    set -g fish_color_command 7dcfff
    set -g fish_color_keyword bb9af7
    set -g fish_color_quote e0af68
    set -g fish_color_redirection c0caf5
    set -g fish_color_end ff9e64
    set -g fish_color_error f7768e
    set -g fish_color_param 9d7cd8
    set -g fish_color_comment 565f89
    set -g fish_color_selection --background=283457
    set -g fish_color_search_match --background=283457
    set -g fish_color_operator 9ece6a
    set -g fish_color_escape bb9af7
    set -g fish_color_autosuggestion 565f89

    # Completion Pager Colors
    set -g fish_pager_color_progress 565f89
    set -g fish_pager_color_prefix 7dcfff
    set -g fish_pager_color_completion c0caf5
    set -g fish_pager_color_description 565f89
    set -g fish_pager_color_selected_background --background=283457

       '';
       onVariable = "term_background";
     };
   };
   # }}}

   # Fish configuration ------------------------------------------------------------------------- {{{

   # Aliases
   programs.fish.shellAliases = with pkgs; {
     # Nix related
     drb = "darwin-rebuild build --flake ~/.config/nixpkgs/";
     drs = "darwin-rebuild switch --flake ~/.config/nixpkgs/";
     flakeup = "nix flake update --recreate-lock-file ~/.config/nixpkgs/";
     nb = "nix build";
     nd = "nix develop";
     nf = "nix flake";
     nr = "nix run";
     ns = "nix search";

     # Other
     ".." = "cd ..";
     ":q" = "exit";
     cat = "${bat}/bin/bat";
     ls = "${eza}/bin/exa";
     du = "${du-dust}/bin/dust";
     g = "${gitAndTools.git}/bin/git";
     la = "ll -a";
     ll = "ls -l --time-style long-iso --icons";
     ps = "${procs}/bin/procs";
     tb = "toggle-background";
   };

   # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
   programs.fish.shellInit = ''
     set -U fish_term24bit 1
     ${lib.optionalString pkgs.stdenv.isDarwin "set-background-to-macOS"}
   '';

   programs.fish.interactiveShellInit = ''
     set -g fish_greeting ""
     ${pkgs.thefuck}/bin/thefuck --alias | source
     # Run function to set colors that are dependant on `$term_background` and to register them so
     # they are triggerd when the relevent event happens or variable changes.
     set-shell-colors
     # Set Fish colors that aren't dependant the `$term_background`.
     set -g fish_color_quote        cyan      # color of commands
     set -g fish_color_redirection  brmagenta # color of IO redirections
     set -g fish_color_end          blue      # color of process separators like ';' and '&'
     set -g fish_color_error        red       # color of potential errors
     set -g fish_color_match        --reverse # color of highlighted matching parenthesis
     set -g fish_color_search_match --background=yellow
     set -g fish_color_selection    --reverse # color of selected text (vi mode)
     set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
     set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
     set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command

     fish_add_path -p -g /run/current-system/sw/bin/

     fish_add_path -p -g /Users/rd/.nix-profile/bin
     set -g SSH_AUTH_SOCK /Users/rd/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

     if test -e '/Users/rd/.nix-profile/etc/profile.d/nix.sh'
       fenv source '/Users/rd/.nix-profile/etc/profile.d/nix.sh'
     end
   '';
   # }}}

   # Starship Prompt
   # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
   programs.starship.enable = true;

   # Starship settings -------------------------------------------------------------------------- {{{

   programs.starship.settings = {
     # See docs here: https://starship.rs/config/

     directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
     directory.truncation_length = 2; # number of directories not to truncate
     gcloud.disabled = true; # annoying to always have on
     hostname.style = "bold green"; # don't like the default
     memory_usage.disabled = true; # because it includes cached memory it's reported as full a lot
     username.style_user = "bold blue"; # don't like the default
   };
   # }}}
 }
