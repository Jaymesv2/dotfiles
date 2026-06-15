{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
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

    awww.url = "git+https://codeberg.org/LGFae/awww";
    awww.inputs.nixpkgs.follows = "nixpkgs";
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
        flake = { inherit flakeModules; } // {
        };
        perSystem = {config, pkgs, pkgs-unstable, system, ...}: let 
            pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };

        in {
            packages.wifiman = pkgs-unstable.callPackage ./pkgs/wifiman.nix {};
            # packages.default = home-manager.defaultPackage;
            _module.args.pkgs = import inputs.nixpkgs {
                inherit system;
                overlays = [
                    inputs.awww.overlays.default
                  # inputs.foo.overlays.default
                  # ( final: prev: { } )
                ];
              };
        };
    });
}
