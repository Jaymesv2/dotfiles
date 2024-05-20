{ lib, config, pkgs, pkgs-unstable, nixpkgs, nixpkgs-unstable, nixpkgs2311, ... }:
  # Check this for having the flake set the system channels
  # https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798
let 
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
  nixpkgsUnstablePath = "${base}/nixpkgs-unstable";
  nixpkgs2311Path = "${base}/nixpkgs2311";
in {
  nix = {
    # pkgs.nixFlakes is an alias for pkgs.nixVersions.stable

    registry.nixpkgs.flake = nixpkgs;
    registry.nixpkgs2311.flake = nixpkgs2311;
    registry.nixpkgs-unstable.flake = nixpkgs-unstable;

    nixPath = [
      "nixpkgs=${nixpkgsPath}"
      "nixpkgs2311=${nixpkgs2311Path}"
      "nixpkgs-unstable=${nixpkgs-unstable}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ ${nixpkgsPath}         - - - - ${nixpkgs}"
    "L+ ${nixpkgsUnstablePath} - - - - ${nixpkgs-unstable}"
    "L+ ${nixpkgs2311Path}     - - - - ${nixpkgs2311}"
  ];
}
