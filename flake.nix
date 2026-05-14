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
    
    # the v1.0.0 nixos module for auto enroll breaks with impermanence
    lanzaboote.url = "github:nix-community/lanzaboote/master";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    nix-amd-npu.url = "github:robcohen/nix-amd-npu";
    nix-amd-npu.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    cwcwm.url = "github:Cudiph/cwcwm";
    cwcwm.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";


    mcphub.url = "github:ravitemer/mcp-hub";
    mcphub.inputs.nixpkgs.follows = "nixpkgs";

    mcphub-nvim.url = "github:ravitemer/mcphub.nvim"; # neovim plugin
    mcphub-nvim.inputs.nixpkgs.follows = "nixpkgs";

    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    mcp-servers-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    # lam.url = "/home/trent/Documents/code/python/Linux-Arctis-Manager";
    
    self.submodules = true;
  };

  outputs = inputs@{flake-parts, nixpkgs, home-manager, nix-gaming, nixpkgs-unstable, nix-index-database, sops-nix,  ... }: 
    flake-parts.lib.mkFlake { inherit inputs; } (top@{config, withSystem, moduleWithSystem, flake-parts-lib, ...}: let
      inherit (flake-parts-lib) importApply;
      flakeModules = {
          homeConfigurations = ./modules/flake-parts/homeConfigurations.nix;
          desktop = importApply ./configurations/desktop.nix { inherit withSystem; };
          laptop = importApply  ./configurations/laptop.nix { inherit withSystem; };
      };
    in {
        imports = [
            flakeModules.desktop
            flakeModules.homeConfigurations
            flakeModules.laptop
        ];
        systems = [
            "x86_64-linux"
        ];
        perSystem = {config, pkgs, system, ...}: {
          #   _module.args.pkgs = import inputs.nixpkgs {
          #   inherit system;
          #   overlays = [
          #     # inputs.foo.overlays.default
          #     # (final: prev: {
          #     #   # ... things you need to patch ...
          #     # })
          #   ];
          #   config = { 
          #       allowUnfree = true;
          #   };
          # };
        };
        flake = { inherit flakeModules; }  // {



    nixosConfigurations = {


      desktop-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [ 
            ./configurations/nixos/desktop-wsl.nix
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

     #  nixosVM = nixpkgs.lib.nixosSystem {
     #    system = "x86_64-linux";
	    # modules = [     
     #        ./system/configuration.nix 
     #        inputs.sops-nix.nixosModules.sops 
					#
     #        inputs.home-manager.nixosModules.home-manager
     #        {
     #            home-manager.useGlobalPkgs = true;
     #            home-manager.useUserPackages = true;
     #            home-manager.users.trent = import ./home/home.nix;
					#
     #            home-manager.extraSpecialArgs = {
     #              nix-gaming = inputs.nix-gaming;
     #              pkgs-unstable = import nixpkgs-unstable {
     #                system = "x86_64-linux";
     #                config.allowUnfree = true;
     #              };
     #              sops-nix = inputs.sops-nix;
     #            };
     #            nixpkgs.config.permittedInsecurePackages = [
     #                "electron-27.3.11"
     #            ];
					#
     #            home-manager.sharedModules = [
     #                inputs.sops-nix.homeManagerModules.sops
     #            ];
     #        }
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
    };


        };
    });

  # inputs: with inputs; {
    # packages = let
    #     pkgs = import nixpkgs { system = "x86_64-linux"; };
    # in ((import ./pkgs/default.nix) {pkgs};)
    
    # defaultPackage = home-manager.defaultPackage;

}
