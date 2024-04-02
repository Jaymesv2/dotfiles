# My Nixos + Home manager Config
The config is at `~/.config/nix` and is symlinked to `~/.config/home-manager` and `/etc/nixos`.
The symlinks make `nixos-rebuild` and `home-manager` happy because the flake is avaliable where each tool expects their config to be at.