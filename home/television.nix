{pkgs, options,config,lib,...}: {
  programs.television = {
    enable = true;
    enableZshIntegration = true;
    channels = {
      # all of the nix indexes
      nix = {
        metadata = {
          description = "Nix Related Indexes";
          name = "nix";
          requirements = [ "nix-search-tv" ];
        };
        preview = {
          command = "nix-search-tv preview --indexes home-manager,nixos,nixpkgs '{}'";
        };
        source = {
          command = "nix-search-tv print --indexes home-manager,nixos,nixpkgs";
        };
      };
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
          command = "nix-search-tv preview --indexes nixos '{}'";
        };
        source = {
          command = "nix-search-tv print --indexes nixos";
        };
      };
      pkgs = {
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
