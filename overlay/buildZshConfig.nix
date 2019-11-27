# Helper script for building my ZSH configuration

{ lib, zsh, writeTextFile, ... }:
{ # Name of the derivation
  name ? "zsh-config"
# Path inside the derivation where to store the config file
, destination ? "/etc/zsh-config.zsh"
# Extra scripts to `source`
, sources ? []
# Extra additions to the function search path
, fpath ? []
# Extra additions to the PATH variable
, path ? []
# Mapping of shell aliases, e.g. { "wtf" = "dmesg" }
, aliases ? {}
, base-options ? [
        "alwaystoend"
        "completeinword"
        "extendedhistory"
        "noflowcontrol"
        "histexpiredupsfirst"
        "histignoredups"
        "histignorespace"
        "histverify"
        "interactivecomments"
        "longlistjobs"
        "promptsubst"
        "pushdignoredups"
        "pushdminus"
        "sharehistory"
    ]
, extra-options ? []
# A custom piece of zsh script that is pasted verbatim at the end of the generated file
, custom ? ""
# File for storing the zsh command history
, histfile ? "$HOME/.zsh_history"
# Number of history entries to save
, histsize ? 50000
# Several styling parameters
, zstyle ? {}
}:
let
    code-sources = lib.concatMapStringsSep "\n" (src: "source ${src}") sources;
    code-fpath = lib.concatMapStringsSep " " (p: "\"${p}\"") fpath;
    code-path = lib.concatStringsSep ":" path;
    code-aliases = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "alias ${name}='${value}'") aliases
    );
    code-setopt = lib.concatStringsSep " " (base-options ++ extra-options);
in
    writeTextFile {
        inherit name;
        inherit destination;
        executable = false;
        text = ''
            export PATH=${code-path}:$PATH
            # Set function path (where autoload looks for functions, needed for some completion scripts)
            fpath=(${code-fpath} $fpath)

            # This is for providing the fg/bg color arrays
            autoload -U colors && colors

            # This is for native zsh and bash compatibility autocompletion
            autoload -U compinit && compinit
            autoload -U +X bashcompinit && bashcompinit

            # Apply history config
            HISTFILE="${histfile}"
            HISTSIZE="${toString histsize}"
            SAVEHIST="${toString histsize}"

            # Source sourceable files
            ${code-sources}

            # Set aliase, as defined above
            ${code-aliases}

            # Set shell options, they have various effects
            setopt ${code-setopt}

            # Provide a navigatable selection menu for completions
            zstyle ':completion:*' menu select
            # colored ls output
            zstyle ':completion:*' list-colors 'rs=0' 'di=01;34' 'ln=01;36' 'mh=00' 'pi=40;33' 'so=01;35' 'do=01;35' 'bd=40;33;01' 'cd=40;33;01' 'or=40;31;01' 'mi=00' 'su=37;41' 'sg=30;43' 'ca=30;41' 'tw=30;42' 'ow=34;42' 'st=37;44' 'ex=01;32' '*.tar=01;31' '*.tgz=01;31' '*.arc=01;31' '*.arj=01;31' '*.taz=01;31' '*.lha=01;31' '*.lz4=01;31' '*.lzh=01;31' '*.lzma=01;31' '*.tlz=01;31' '*.txz=01;31' '*.tzo=01;31' '*.t7z=01;31' '*.zip=01;31' '*.z=01;31' '*.Z=01;31' '*.dz=01;31' '*.gz=01;31' '*.lrz=01;31' '*.lz=01;31' '*.lzo=01;31' '*.xz=01;31' '*.zst=01;31' '*.tzst=01;31' '*.bz2=01;31' '*.bz=01;31' '*.tbz=01;31' '*.tbz2=01;31' '*.tz=01;31' '*.deb=01;31' '*.rpm=01;31' '*.jar=01;31' '*.war=01;31' '*.ear=01;31' '*.sar=01;31' '*.rar=01;31' '*.alz=01;31' '*.ace=01;31' '*.zoo=01;31' '*.cpio=01;31' '*.7z=01;31' '*.rz=01;31' '*.cab=01;31' '*.wim=01;31' '*.swm=01;31' '*.dwm=01;31' '*.esd=01;31' '*.jpg=01;35' '*.jpeg=01;35' '*.mjpg=01;35' '*.mjpeg=01;35' '*.gif=01;35' '*.bmp=01;35' '*.pbm=01;35' '*.pgm=01;35' '*.ppm=01;35' '*.tga=01;35' '*.xbm=01;35' '*.xpm=01;35' '*.tif=01;35' '*.tiff=01;35' '*.png=01;35' '*.svg=01;35' '*.svgz=01;35' '*.mng=01;35' '*.pcx=01;35' '*.mov=01;35' '*.mpg=01;35' '*.mpeg=01;35' '*.m2v=01;35' '*.mkv=01;35' '*.webm=01;35' '*.ogm=01;35' '*.mp4=01;35' '*.m4v=01;35' '*.mp4v=01;35' '*.vob=01;35' '*.qt=01;35' '*.nuv=01;35' '*.wmv=01;35' '*.asf=01;35' '*.rm=01;35' '*.rmvb=01;35' '*.flc=01;35' '*.avi=01;35' '*.fli=01;35' '*.flv=01;35' '*.gl=01;35' '*.dl=01;35' '*.xcf=01;35' '*.xwd=01;35' '*.yuv=01;35' '*.cgm=01;35' '*.emf=01;35' '*.ogv=01;35' '*.ogx=01;35' '*.aac=00;36' '*.au=00;36' '*.flac=00;36' '*.m4a=00;36' '*.mid=00;36' '*.midi=00;36' '*.mka=00;36' '*.mp3=00;36' '*.mpc=00;36' '*.ogg=00;36' '*.ra=00;36' '*.wav=00;36' '*.oga=00;36' '*.opus=00;36' '*.spx=00;36' '*.xspf=00;36'

            # Run custom initialization code
            ${custom}
        '';
    }
