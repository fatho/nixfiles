pkgs:
let
    git-prompt = ''
        git_prompt_info () {
            local ref
            local version
            local gitinfo
            local dirty

            ref=$(command git symbolic-ref HEAD 2> /dev/null) || ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
            gitinfo="%{$fg[yellow]%}''${ref#refs/heads/}%{$reset_color%} "

            version=$(command git describe --exact-match HEAD 2> /dev/null)
            if [ $? -eq 0 ]; then
                gitinfo+="$%{$fg[yellow]%}($version)%{$reset_color%} "
            fi

            dirty=$(command git status --porcelain 2> /dev/null | tail -n1)
            if [[ -n $STATUS ]]; then
                gitinfo+="%{$fg[red]%} ✘%{$reset_color%} "
            fi

            echo "$gitinfo"
        }
    '';

    shell-level-info = ''
        shlvl_info () {
            if [ $SHLVL -gt 1 ]; then
                echo "($SHLVL) "
            fi
        }
    '';
in
pkgs.fatho.buildZshConfig {
    sources = [
        (pkgs.autojump + "/share/autojump/autojump.zsh")
        (pkgs.zsh-history-substring-search + "/share/zsh-history-substring-search/zsh-history-substring-search.zsh")
    ];
    fpath = [
        (pkgs.nix-zsh-completions + "/share/zsh/site-functions")
        (pkgs.autojump + "/share/zsh/site-functions")
    ];
    path = [
        "/home/fatho/.local/bin"
    ];
    aliases = {
        "wtf" = "dmesg";
        "wttr" = "curl -sS http://wttr.in/Utrecht | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} -v \"New feature\\\\|Follow\"";
        "sb" = "stack build --test --bench --no-run-benchmarks --no-run-tests --ghc-options='-j4 +RTS -A64m -RTS'";
        "sbh" = "stack build --test --bench --no-run-benchmarks --no-run-tests --haddock --no-haddock-deps --ghc-options='-j4 +RTS -A64m -RTS'";
        "sbb" = "stack build --test --bench --no-run-tests --ghc-options='-j4 +RTS -A64m -RTS'";
        "st" = "stack test --bench --no-run-benchmarks --ghc-options='-j4 +RTS -A64m -RTS'";
        "screenshot" = "import png:- | xclip -selection clipboard -t image/png";
        "ls" = "ls --color=tty";
        "la" = "ls -lAh";
        "nix-venv" = "nix run -c $SHELL";
    };
    custom = ''
        # Dynamically generated aliases
        eval $(thefuck --alias)
        eval $(thefuck --alias FUCK)
        ${git-prompt}
        ${shell-level-info}

        # Search the history with what was already typed when pushing up/down
        bindkey "^[[A" history-substring-search-up
        bindkey "^[[B" history-substring-search-down
        # Alternative:
        # up/down-line-or-beginning-search

        # NOTE: On the office computer, it's the following instead, weird stuff
        # bindkey "$terminfo[kcuu1]" history-substring-search-up
        # bindkey "$terminfo[kcud1]" history-substring-search-down

        # Bind Ctrl+Left/Right
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        # Bind home/end/delete
        bindkey  "^[[H"   beginning-of-line
        bindkey  "^[[F"   end-of-line
        bindkey  "^[[3~"  delete-char

        # Prompt
        PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
        PROMPT+='%{$reset_color%}$(shlvl_info) %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

        # Set global (ugh) config
        export EDITOR=vim
    '';
}