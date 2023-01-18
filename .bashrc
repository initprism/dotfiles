# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

### BIN PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.ghcup/bin" ] ;
  then PATH="$HOME/.ghcup/bin:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ] ;
  then PATH="$HOME/.cabal/bin:$PATH"
fi

### SETTING OTHER ENVIRONMENT VARIABLES
if [ -z "$XDG_CONFIG_HOME" ] ; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ] ; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_CACHE_HOME" ] ; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

### EXPORT XMONAD DIR
export XMONAD_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" export XMONAD_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"

export XMONAD_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

### EDITOR

alias e='helix'

alias hx='helix'

### COMMON 

alias ls='ls --color=auto'

alias l='ls'

alias ll='ls -l'

alias lal='ls -al'

alias cp="cp -i"

alias mv='mv -i'

alias rm='rm -i'

### MOVE
alias ..='cd ..'

alias ...='cd ../..'

alias .3='cd ../../..'

alias .4='cd ../../../../'

alias .5='cd ../../../../../'

alias psa="ps auxf"

alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

alias psmem='ps auxf | sort -nr -k 4'

alias pscpu='ps auxf | sort -nr -k 3'

### PACMAN & YAY

alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs

alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs

alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)

alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)

alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)

alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)

alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock

alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # remove orphaned packages

#### UPDATE MIRRORLIST

alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"

alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"

alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

### COLORIZE GREP OUTPUT 
alias grep='grep --color=auto'

alias egrep='egrep --color=auto'

alias fgrep='fgrep --color=auto'

### DOTFILE GIT
alias dotfile='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
