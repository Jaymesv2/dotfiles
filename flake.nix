{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
          pkgs-unstable = import nixpkgs {
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
      };
    };
  };
}
