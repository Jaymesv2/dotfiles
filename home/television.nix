{pkgs, options,config,lib,...}: {
  programs.television = {
    enable = true;
    enableZshIntegration = true;
    channels = {
      home-manager = {
        metadata = {
          description = "Home Manager Options";
          name = "hm";
          requirements = [ "nix-search-tv" ];
        };
        preview = {
          command = "nix-search-tv preview --indexes home-manager '{}'";
        };
        source = {
          command = "nix-search-tv print --indexes home-manager";
        };
      };
      nixos = {
        metadata = {
          description = "Nixos Options";
          name = "nixos";
          requirements = [ "nix-search-tv" ];
        };
        preview = {
          command = "nix-search-tv preview --indexes nixpkgs '{}'";
        };
        source = {
          command = "nix-search-tv print --indexes nixpkgs";
        };
      };
      nixpkgs = {
        metadata = {
          description = "Nixpkgs packages";
          name = "pkgs";
          requirements = [ "nix-search-tv" ];
        };
        preview = {
          command = "nix-search-tv preview --indexes nixpkgs '{}'";
        };
        source = {
          command = "nix-search-tv print --indexes nixpkgs";
        };
      };
    };
  };
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
    settings = {
      indexes = ["nixpkgs" "nixos" "home-manager"];
      update_interval = "24h";
    };
  };
  }
