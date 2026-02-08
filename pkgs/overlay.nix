final: prev: {
    stackCollapse = final.callPackage ./utils/stackCollapse.nix {};
    nixFunctionCalls = final.callPackage ./utils/nixFunctionCalls.nix {};
}
