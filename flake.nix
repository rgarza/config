{
  description = "Nix system configs.";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;    
    nixpkgs-master.url = github:NixOS/nixpkgs/master;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-21.11-darwin;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;    

    # Environment/system management
    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { nixpkgs, self, darwin, home-manager, flake-utils, ... }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              starship;
          })
        );
      };

      homeManagerStateVersion = "22.05";
      homeManagerCommonConfig = {
        imports = attrValues self.homeManagerModules ++ [
          ./home
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        ./darwin
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;
            nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
            users.users.${primaryUser}.home = "/Users/${primaryUser}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser} = homeManagerCommonConfig;
            nix.registry.my.flake = self;
          }
        )
      ];
      # }}}
    in
    {

      darwinConfigurations = rec {    
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };    
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        mb = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = "rd";
              networking.computerName = "mb 💻";
              networking.hostName = "mb";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];
        };
      };

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = final: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = final: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = final: prev: {
          pkgs-unstable = import inputs.nixpkgs {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
  
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          pkgs-x86 = import inputs.nixpkgs {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };   
        colors = import ./overlays/colors.nix;

        ipythonFix = self: super: {
          python3 = super.python3.override {
            packageOverrides = pySelf: pySuper: {
              ipython = pySuper.ipython.overridePythonAttrs (old: {
                preCheck = old.preCheck + super.lib.optionalString super.stdenv.isDarwin ''
                  echo '#!${super.stdenv.shell}' > pbcopy
                  chmod a+x pbcopy
                  cp pbcopy pbpaste
                  export PATH="$(pwd)''${PATH:+":$PATH"}"
                '';
              });
            };
            self = self.python3;
          };
        };
      };

     
      darwinModules = {
        programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        security-pam = import ./modules/darwin/security/pam.nix;
        users = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        configs-git-aliases = import ./home/configs/git/git-aliases.nix;
        configs-gh-aliases = import ./home/configs/git/gh-aliases.nix;   
        configs-starship-symbols = import ./home/configs/starship-symbols.nix;   
        programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;

      };      
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable
          apple-silicon
        ];
      };
    });
}
