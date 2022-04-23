{
    description = "flake for elixir phoenix postgresql";
    
    inputs = {
        nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    };
    

    outputs = { self, nixpkgs }: 
    let
        supportedSystems = [ "aarch64-darwin" ];
        forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
        
    in {
        devShell = forAllSystems(system: 
            let
                pkgs = nixpkgsFor.${system};
                erlang = pkgs.beam.interpreters.erlangR24;
                elixir = pkgs.beam.packages.erlangR24.elixir_1_13;
                inotify-tools = pkgs.inotify-tools;
                postgresql = pkgs.postgresql_14;
                nodejs = pkgs.nodejs-17_x;
            in
                with pkgs;
                let
                    inherit (lib) optional optionals;                
                in
                    mkShell {
                        buildInputs = with pkgs; [ 
                            erlang
                            elixir
                            nodejs
                            yarn
                            postgresql
                        ]
                        ++ optional stdenv.isLinux inotify-tools
                        ++ optional stdenv.isDarwin terminal-notifier
                        ++ optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
                                CoreFoundation
                                CoreServices
                            ]
                        );
                        shellHook = ''
                            mkdir -p .nix-node
                            mkdir -p .nix-mix
                            mkdir -p .nix-hex
                            export MIX_HOME=$PWD/.nix-mix
                            export HEX_HOME=$PWD/.nix-hex
                            export PATH=$MIX_HOME/bin:$PATH
                            export PATH=$HEX_HOME/bin:$PATH
                            export LANG=en_US.UTF-8
                            export NODE_PATH=$PWD/.nix-node
                            export NPM_CONFIG_PREFIX=$PWD/.nix-node
                            export PATH=$NODE_PATH/bin:$PATH

                            yes | mix local.hex
                            yes | mix archive.install hex phx_new
                            # setup postgres, https://gist.github.com/zoedsoupe/e562e4caa7349ee26156fce8fd1a945e
                            export PGHOST=$PWD/.postgres
                            export PGDATA=$PGHOST/data
                            export PGLOG=$PGHOST/postgres.log
                            export PGPASSWORD=postgres

                            if [ ! -d $PGDATA ]; then
                            echo 'Initializing postgresql database...'
                                initdb --auth=trust --no-locale --encoding=UTF8 >/dev/null
                            fi
                            pg_ctl start -l $PGLOG -o "--unix_socket_directories='$PGHOST'"

                            psql -d postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'" | grep -q 1 \
                                || createuser -s postgres
                            
                            finish() {
                                pg_ctl -D $PGDATA stop
                            }
                            trap finish EXIT
                        '';  
                    }                 
            );
            
            
    };
}