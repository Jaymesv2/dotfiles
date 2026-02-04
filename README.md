# My Nixos + Home manager Config
The config is at `~/.config/nix` and is symlinked to `~/.config/home-manager` and `/etc/nixos`.
The symlinks to make `nixos-rebuild` (`/etc/nixos`) and `home-manager` (`~/.config/home-manager`) happy are both created by their respective configs and therefore need to have a generation activated using `--flake` before `nixos-rebuild` or `home-manager` will automatically recognize the configs.

