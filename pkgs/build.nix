let 
    pkgs = import <nixpkgs> { system = "x86_64-linux"; }; 
in 
    ((import ./default.nix) pkgs).ipfs-desktop
    # pkgs.callPackage ./ipfs-desktop.nix {}
