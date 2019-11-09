# Package set for usage with
#
# nix-env -irf profile.nix
#

let
    homepkgs = import ./homepkgs;
    pkgs = import <nixpkgs> { overlays = [homepkgs]; };
in
    with pkgs; [
        # Nix
        nix
        nix-prefetch-hg
        nix-prefetch-git
        fatho.nix-locale
        cachix

        # Git
        gitAndTools.git-annex

        # Profiling
        linuxPackages.perf
        flamegraph
        fatho.perf-flame

        # Haskell
        haskellPackages.cabal-install
        haskellPackages.stack
        haskellPackages.ghcid
        haskellPackages.hlint
        haskellPackages.apply-refact
        haskellPackages.profiteur
        haskellPackages.stylish-haskell

        # Rust
        carnix
    ]