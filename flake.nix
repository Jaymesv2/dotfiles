{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    # nix-gaming.inputs.nixpkgs.flollows = "nixpkgs";
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
        };
        modules = [ ./home.nix ];
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	    modules = [ ./system/configuration.nix ];
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
