{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    # nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: with inputs; {
    defaultPackage = home-manager.defaultPackage;

    homeConfigurations = {
      trent = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
	      system = "x86_64-linux";
	      config.allowUnfree = true;
	      # required by logseq and obsidian
	      config.permittedInsecurePackages = [
            "electron-25.9.0"
          ];
	    };
	    extraSpecialArgs = {
          nix-gaming = inputs.nix-gaming;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          sops-nix = inputs.sops-nix;

        };
        modules = [ 
            ./home.nix 
            sops-nix.homeManagerModules.sops
        ];
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [ ./system/configuration.nix inputs.sops-nix.nixosModules.sops ];
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
          };
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          nixpkgs2311 = nixpkgs;
        };
      };

     #  desktop = nixpkgs.lib.nixosSystem {
     #    system = "x86_64-linux";
     #    module = [ 
     #        ./system/desktop.nix 
     #        inputs.disko.nixosModules.disko
     #        inputs.sops-nix.nixosModules.sops 
     #        ./system/desktop-disk.nix
     #    ];
     #    specialArgs = {
     #      pkgs-unstable = import nixpkgs-unstable {
     #        system = "x86_64-linux";
     #      };
     #      nixpkgs = nixpkgs;
     #      nixpkgs-unstable = nixpkgs-unstable;
     #      nixpkgs2311 = nixpkgs;
     #    };
     #  };

      nixosVM = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [     
            ./system/configuration.nix 
            inputs.sops-nix.nixosModules.sops 

            inputs.home-manager.nixosModules.home-manager
            {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.trent = import ./home.nix;

                home-manager.extraSpecialArgs = {
                  nix-gaming = inputs.nix-gaming;
                  pkgs-unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                  sops-nix = inputs.sops-nix;
                };
                nixpkgs.config.permittedInsecurePackages = [
                    "electron-27.3.11"
                ];

                home-manager.sharedModules = [
                    inputs.sops-nix.homeManagerModules.sops
                ];
            }
        ];
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
          };
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          nixpkgs2311 = nixpkgs;
        };
      };
    };
  };
}
