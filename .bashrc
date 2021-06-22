case "$OSTYPE" in
  darwin*)  source ~/.macrc ;;
  linux*)   source ~/.ubunturc ;;
  bsd*)     echo "BSD" ;;
  msys*)    echo "WINDOWS" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)"

# test if interactive
if [ ! -z "$PS1" ]; then
    # Lang env variable
    export LC_ALL=en_US.UTF-8 # w/o this, can't import e.g. matplotlib? wtf?
    export LANG=en_US.UTF-8

    # color grep commands
    alias la='ls -a'
    alias ls='ls -FG'
    alias ll='ls -ahl'
    # print large files
    alias diskspace="du -hS | sort -h -r | more"
    # show size of folders in current dir
    alias folders='du -a -h --max-depth=1 | sort -hr'

    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias .....="cd ../../../.."

    alias vi="vim"

    alias dick=git
    if [ -x "$(command -v nvim)" ]; then
        alias vi='nvim'
        alias vim='nvim'
        export VISUAL=nvim
    else
        export VISUAL=vim
    fi

    if [ -x "$(command -v fzf)" ]; then
        alias edit='vim $(fzf)'
    fi
    export EDITOR=$VISUAL


    extract () {
       if [ -f "$1" ] ; then
           case "$1" in
               *.tar.bz2)   tar xvjf $1    ;;
               *.tar.gz)    tar xvzf $1    ;;
               *.bz2)       bunzip2 $1     ;;
               *.rar)       unrar x $1     ;;
               *.gz)        gunzip $1      ;;
               *.tar)       tar xvf $1     ;;
               *.tbz2)      tar xvjf $1    ;;
               *.tgz)       tar xvzf $1    ;;
               *.zip)       unzip $1       ;;
               *.Z)         uncompress $1  ;;
               *.7z)        7z x $1        ;;
               *.tar.xz)    tar xvfJ $1    ;;
               *)           echo "don't know how to extract '$1'..." ;;
           esac
       else
           echo "'$1' is not a valid file!"
       fi
    }

    # enable ctrl-s
    stty -ixon

    # dedup history
    export HISTCONTROL=ignoreboth:erasedups
    export HISTTIMEFORMAT="%y-%m-%d %T "

    ################################################################################
    #                       Stuff from mrzool/bash-sensible                        #
    ################################################################################
    # Unique Bash version check
    if ((BASH_VERSINFO[0] < 4))
    then
        echo "sensible.bash: Looks like you're running an older version of Bash."
        echo "sensible.bash: You need at least bash-4.0 or some options will not work correctly."
        echo "sensible.bash: Keep your software up-to-date!"
    fi

    # Prevent file overwrite on stdout redirection
    # Use `>|` to force redirection to an existing file
    set -o noclobber

    # Automatically trim long paths in the prompt (requires Bash 4.x)
    PROMPT_DIRTRIM=2
    #
    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob;

    # Perform file completion in a case insensitive fashion
    bind "set completion-ignore-case on"

    # Display matches for ambiguous patterns at first tab press
    bind "set show-all-if-ambiguous on"

    # Immediately add a trailing slash when autocompleting symlinks to directories
    bind "set mark-symlinked-directories on"

    # Append to the history file, don't overwrite it
    shopt -s histappend

    # Save multi-line commands as one command
    shopt -s cmdhist

    # Record each line as it gets issued
    PROMPT_COMMAND='history -a'

    # Huge history. Doesn't appear to slow things down, so why not?
    HISTSIZE=500000
    HISTFILESIZE=100000

    # Avoid duplicate entries
    HISTCONTROL="erasedups:ignoreboth"

    ## BETTER DIRECTORY NAVIGATION ##

    # Prepend cd to directory names automatically
    shopt -s autocd 2> /dev/null
    # Correct spelling errors during tab-completion
    shopt -s dirspell 2> /dev/null
    # Correct spelling errors in arguments supplied to cd
    shopt -s cdspell 2> /dev/null

    # This defines where cd looks for targets
    # Add the directories you want to have fast access to, separated by colon
    # Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
    CDPATH="."

    if [ -f $HOME/tmux.completion.bash ]; then
        source ~/tmux.completion.bash
    fi


    # must press ctrl-D twice to exit
    export IGNOREEOF="1"

    alias s="git status"
    alias d="git diff"

    alias weather='curl wttr.in/Osnabrueck'

    pycd () {
        pushd `python -c "import os.path, $1; print(os.path.dirname($1.__file__))"`;
    }

    cranemux() {
        cd $PROJDIR
        tmux new-session -ds 0-edit-core
        tmux new-session -ds 1-run-core
        tmux new-session -ds 2-edit-sim
        tmux new-session -ds 3-run-sim
        tmux new-session -ds 4-misc

        tmux send-keys -t 1-run-core "cd $PROJDIR/build" Enter
        tmux send-keys -t 2-edit-sim "cd $PROJDIR/third_party/autocrane-bulletsim" Enter
        tmux send-keys -t 2-edit-sim "source $PROJDIR/autocrane_venv/bin/activate" Enter

        tmux send-keys -t 3-run-sim "cd $PROJDIR/third_party/autocrane-bulletsim" Enter
        tmux send-keys -t 3-run-sim "source $PROJDIR/autocrane_venv/bin/activate" Enter
}


    if [ $(command -v fuck) ]; then
        eval $(thefuck --alias)
    fi
    # To simplify javadoc generation
    alias javadoc='find ./src -name *.java > ./sources_list.txt;javadoc -author -version -d doc @sources_list.txt; rm -f ./sources_list.txt'

    alias bake=make
    try_make () {
        case "$OSTYPE" in
          darwin*)  osascript -e 'display notification "Beginn" with title "Kompilates"';;
          linux*)   spd-say "Start compile" ;;
        esac &

        cmake --build . -j$(getconf _NPROCESSORS_ONLN) -- $@
        res=$?
        if [[ $res -eq 0 ]]; then
            case "$OSTYPE" in
              darwin*)  osascript -e 'display notification "Erfolg" with title "Kompilates"';;
              linux*)   spd-say "Success" ;;
            esac
        else
            case "$OSTYPE" in
              darwin*)  osascript -e 'display notification "Misserfolg" with title "Kompilates"';;
              linux*)   spd-say "Fail" ;;
            esac
        fi
    }
    alias try_bake=try_make

    export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)"

    export PATH=$HOME/Documents/ESP-Toolchain/xtensa-esp32-elf/bin:$PATH
    export IDF_PATH=$HOME/Downloads/esp-idf

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    if [ ! -S ~/.ssh/ssh_auth_sock ]; then
      eval `ssh-agent`
      ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add
fi
