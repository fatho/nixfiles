
# Wrapper around the `nix/etc/profile.d/nix.sh` file that is sourced
# in `.profile` by default when using the nix installer.
# In addition to setting up the user environment, it also sets the
# LOCALE_ARCHIVE variable so that programs relying on glibc locale
# support (such as all Haskell applications in existence) still work.
#
# This derivation is assigned a higher priority (-1) than the default
# priority (0), because it intentionally conflicts with the `nix` derivation.
{ nix, writeTextFile, glibcLocales, lib, ... }:
let
    nix-locale = writeTextFile {
        name = "nix-locale";
        destination = "/etc/profile.d/nix.sh";
        text = ''
            source ${nix}/etc/profile.d/nix.sh
            export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
        '';
    };
in
    nix-locale.overrideAttrs (old: {
        # The documentation lied: 0 is not the highest priority after all...
        meta = { priority = -1; };
    })