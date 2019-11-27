# My personal nix config

This repository contains my personal nix package overlay with some helper scripts
as well as my package set for my nix profile.

The profile packages can be installed with

```bash
# CAUTION: This will remove any other packages from the nix profile
nix-env -irf profile.nix
```

The package overlay can be used from this directory as follows:

```nix
let
    fatho-overlay = import ./overlay;
    pkgs = import <nixpkgs> { overlays = [fatho-overlay]; };
in
    ...
```

From other places, the overlay is best accessed via GitHub:

```nix
let
    fatho-overlay = import (fetchTarball https://github.com/fatho/nixfiles/archive/master.tar.gz + "/overlay");
    pkgs = import <nixpkgs> { overlays = [fatho-overlay]; };
in
    ...
```