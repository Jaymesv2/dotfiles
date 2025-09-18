
{ lib, config, pkgs, pkgs-unstable, ... }: {
  nix = {
    # pkgs.nixFlakes is an alias for pkgs.nixVersions.stable
    package = pkgs.nixVersions.stable;
    gc = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "45min";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      trusted-users = [
        "root"
        "trent"
        "@wheel"
      ];
    };
  };
}
