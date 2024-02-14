
{ home, pkgs, ... }: {

  imports = [ ];


 programs.fzf = {
    enable = true;
    defaultOptions = ["--height 40%" "--layout=reverse" "--border"];
    tmux = {
        enableShellIntegration = true;
    };

    defaultCommand  = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .npm --exclude .vscode-server --exclude .local --exclude .yarn --exclude .cache --exclude .nix-defexpr --exclude .nix-profile --exclude .git --exclude node_modules --type directory" ;
    fileWidgetCommand  = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .npm --exclude .vscode-server --exclude .local --exclude .yarn --exclude .cache --exclude .nix-defexpr --exclude .nix-profile --exclude .git --exclude node_modules --type directory" ;
    enableFishIntegration = true;
  };
}
