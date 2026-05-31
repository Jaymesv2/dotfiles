# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{ lib, config, self, inputs, ... }: let
    inherit (inputs) nixpkgs nixpkgs-unstable home-manager nix-index-database sops-nix;
in 
{
  flake = {

  # perSystem = { system, ... }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
	    modules = [ 

            # inputs.lam.nixosModules.default
            ({ pkgs-unstable, ... }: {
                imports = [ ../pkgs/linux-arctis-manager-module.nix ];
                nixpkgs.overlays = [ (prev: final: {
                    linux-arctis-manager = pkgs-unstable.callPackage ../pkgs/linux-arctis-manager.nix {};
                })];
                services.linux-arctis-manager.enable = true;
            })

            ./nixos/desktop.nix
            inputs.nix-gaming.nixosModules.pipewireLowLatency
            inputs.nix-gaming.nixosModules.platformOptimizations
            # inputs.nix-gaming.nixosModules.default
            inputs.sops-nix.nixosModules.sops 
            inputs.impermanence.nixosModules.impermanence
            inputs.disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-index-database.nixosModules.default 
            # { 
            #     # add the cachyos kernel overlay and 
            #     nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ]; 
            #     nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
            #     nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
            # } 
            inputs.cwcwm.nixosModules.cwc

        ];
      };

      homeConfigurations."trent@desktop" = home-manager.lib.homeManagerConfiguration {
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
            inputs.mcp-servers-nix.homeManagerModules.default
            (./home-manager + "/trent@desktop.nix")
            nix-index-database.homeModules.default
            sops-nix.homeManagerModules.sops
            {
                nixpkgs.overlays = [ 
                    (prev: final: { mcphub = inputs.mcphub.packages."x86_64-linux".default; mcphub-nvim = inputs.mcphub-nvim.packages."x86_64-linux".default; }) 
                    inputs.awww.overlays.default
                ]; 
            }
        ];
      };

    # A copy of hello that was defined by this flake, not the user's flake.
    # packages.greeter = localFlake.withSystem system ({ config, ... }:
    #   config.packages.default
    # );
  # };

  };
}
