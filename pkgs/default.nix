pkgs: rec {
    stackCollapse = pkgs.callPackage ./utils/stackCollapse.nix {};
    nixFunctionCalls = pkgs.callPackage ./utils/nixFunctionCalls.nix {};
    ipfs-desktop = pkgs.callPackage ./ipfs-desktop.nix { inherit ipfs-car; };
    ipfs-car = pkgs.callPackage ./ipfs-car.nix {};
}
