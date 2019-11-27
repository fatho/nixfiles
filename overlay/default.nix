
# This is my personal overlay for nixpks. Use as follows:
#
# import <nixpkgs> { overlays = [mypkgs]; }
self: super:
let
    # My custom packages go in a sub-namespace in order to prevent name clashes
    fatho = {
        nix-locale = self.callPackage (import ./nix-locale.nix) {};
        perf-flame = self.callPackage (import ./perf-flame.nix) {};
        buildZshConfig = self.callPackage (import ./buildZshConfig.nix) {};
    };
in
    {
        inherit fatho;
    }