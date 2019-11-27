# Package set for usage with
#
# nix-env -irf profile.nix
#

let
    fatho-overlay = import ./overlay;
    pkgs = import <nixpkgs> { overlays = [fatho-overlay]; };
    zsh-config = import ./zsh-config.nix pkgs;
in
    with pkgs; [
        # Nix
        nix
        nix-prefetch-hg
        nix-prefetch-git
        fatho.nix-locale
        cachix

        # Shell
        autojump
        thefuck
        zsh-config

        # Git
        gitAndTools.git-annex

        # Profiling
        linuxPackages.perf
        flamegraph
        fatho.perf-flame

        # Haskell
        haskellPackages.ghcid
        haskellPackages.hlint
        haskellPackages.apply-refact
        haskellPackages.profiteur
        haskellPackages.stylish-haskell

        # Rust
        carnix
    ]