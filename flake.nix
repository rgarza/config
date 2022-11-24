{
  description = "Nix system configs.";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;    
    nixpkgs-master.url = github:NixOS/nixpkgs/master;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-22.05-darwin;
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
          final: prev: ({
            inherit (final.pkgs-master)
              flyctl;
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

    primaryUserInfo = {
      username = "rd";
      fullName = "Rene de la Garza";
      email = "rene@r3n3.co";
      nixConfigDirectory = "/Users/rd/.nixpkgs";
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
            # nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
            nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; };
            users.users.${primaryUser.username}.home = "/Users/${primaryUser.username}";
            home-manager.useGlobalPkgs = true;

            home-manager.users.${primaryUser.username} = homeManagerCommonConfig;
            
            # {
            #   imports = attrValues self.homeManagerModules ++ [
            #     ./home
            #   ];
            #   home.stateVersion = homeManagerStateVersion;
            #   home.user-info = config.users.primaryUser;
            # };            
            
            nix.registry.my.flake = self;
          }
        )
      ];
      # }}}
    in
    {

      darwinConfigurations = rec {    
        bootstrap-arm = makeOverridable darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };    

        mb = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
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
            # overlays = attrValues self.overlays ++ singleton (
            #   final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            #     inherit (final.pkgs-x86)
            #       starship; # using version because https://github.com/NixOS/nixpkgs/pull/159937
            #   })
            # );
          };
        };   
        vimUtils = import ./overlays/vimUtils.nix;

        vimPlugins = final: prev:
          let
            inherit (self.overlays.vimUtils final prev) vimUtils;
          in
          {
            vimPlugins = prev.vimPlugins.extend (_: _:
              vimUtils.buildVimPluginsFromFlakeInputs inputs [
                # Add flake input name here
              ]
            );
          };
        

        # ipythonFix = self: super: {
        #   python3 = super.python3.override {
        #     packageOverrides = pySelf: pySuper: {
        #       ipython = pySuper.ipython.overridePythonAttrs (old: {
        #         preCheck = old.preCheck + super.lib.optionalString super.stdenv.isDarwin ''
        #           echo '#!${super.stdenv.shell}' > pbcopy
        #           chmod a+x pbcopy
        #           cp pbcopy pbpaste
        #           export PATH="$(pwd)''${PATH:+":$PATH"}"
        #         '';
        #       });
        #     };
        #     self = self.python3;
        #   };
        # };
      };

     
      darwinModules = {
        programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        # security-pam = import ./modules/darwin/security/pam.nix;
        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        configs-starship-symbols = import ./home/configs/starship-symbols.nix;   
        configs-neovim = import ./home/neovim.nix;
        # programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };

      };      
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = attrValues {
          inherit (self.overlays)
          pkgs-master
          pkgs-stable
          apple-silicon;
        };
      };

      devShells =
      let
        pkgs = self.legacyPackages.${system};
      in
      {
        python = pkgs.mkShell {
          name = "python310";
          inputsFrom = attrValues {
            inherit (pkgs.pkgs-master.python310Packages) black isort;
            inherit (pkgs) poetry python310 pyright;
          };
        };
      };
    });
}
