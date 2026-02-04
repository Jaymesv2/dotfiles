{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    # nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    nix-amd-npu.url = "github:robcohen/nix-amd-npu";
    nix-amd-npu.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    cwcwm.url = "github:Cudiph/cwcwm";
    cwcwm.inputs.nixpkgs.follows = "nixpkgs";

    self.submodules = true;
  };

  outputs = inputs: with inputs; {
    defaultPackage = home-manager.defaultPackage;
    homeConfigurations = {
      # laptop config
      "trent@nixos" = home-manager.lib.homeManagerConfiguration {
      # "trent@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
	      system = "x86_64-linux";
	      config.allowUnfree = true;
	      # required by logseq and obsidian
	      # config.permittedInsecurePackages = [ "electron-25.9.0" ];
	    };
	    extraSpecialArgs = {
          nix-gaming = inputs.nix-gaming;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          sops-nix = inputs.sops-nix;
        };
        #minimal = true; # I want to enable this later but don't have the time rn
        modules = [ 
            ./home.nix 
            sops-nix.homeManagerModules.sops
        ];
      };
      # wsl config
      /* "trent@desktop-wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
	      system = "x86_64-linux";
	      config.allowUnfree = true;
	    };
        modules = [ 
             (./. + "/configurations/home-manager/trent@desktop-wsl/home.nix")
            # ./home/nvim/nvim.nix
            # sops-nix.homeManagerModules.sops
        ];
	    extraSpecialArgs = {
          # nix-gaming = inputs.nix-gaming;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          # sops-nix = inputs.sops-nix;
					#
        };
      }; */
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [ 
            ./system/configuration.nix 
            inputs.sops-nix.nixosModules.sops 
            inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series 
            inputs.impermanence.nixosModules.impermanence
            inputs.disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
            nix-amd-npu.nixosModules.default
            { 
                # add the cachyos kernel overlay and 
                nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ]; 
                nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
                nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
                hardware.amd-npu.enable = true;
            } 
            inputs.cwcwm.nixosModules.cwc

        ];
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            overlays = [
                inputs.cwcwm.overlays.default # add cwc to unstable
            ];
          };
          nixpkgs = nixpkgs;
          nixpkgs-unstable = nixpkgs-unstable;
          nixpkgs2311 = nixpkgs;
        };
      };
      desktop-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [ 
            ./configurations/nixos/desktop-wsl/configuration.nix
            inputs.nixos-wsl.nixosModules.wsl
            # ./system/configuration.nix 
            # inputs.sops-nix.nixosModules.sops 
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
