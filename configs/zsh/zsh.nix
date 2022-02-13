{ pkgs, ... }:
{
    programs.zsh = {
        initExtra = ''
   	export SSH_AUTH_SOCK=/Users/rd/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh	
            export PATH=/var/run/current-system/sw/bin/:$HOME/.nix-profile/bin:$PATH:/usr/local/bin
            if [[ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
            source "$HOME/.nix-profile/etc/profile.d/nix.sh"
            fi        
            source ${./p10k.zsh}
            
        '';
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;

        history = {
            expireDuplicatesFirst = true;            
            extended = true;
            size = 100000;
            save = 100000;
        };
        oh-my-zsh = {
            enable = true;
        };

        shellAliases = {
        };
        plugins = [
            {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
        ];

    };
}
