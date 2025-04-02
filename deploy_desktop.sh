#!/usr/bin/env bash

nix run github:nix-community/nixos-anywhere -- --disko-mode mount --flake .#desktop --target-host root@10.2.0.121
