### REMOVE GREETING MESSAGE
set fish_greeting 

### REMOVE THE DEFAULT USER PATH
set -e fish_user_paths 

### BIN PATH
set -U fish_user_paths $HOME/.bin $fish_user_paths

set -U fish_user_paths $HOME/local/.bin $fish_user_paths

set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

set -U fish_user_paths $HOME/.ghcup/bin $fish_user_paths

set -U fish_user_paths $HOME/.cabal/bin $fish_user_paths

### SETTING OTHER ENVIRONMENT VARIABLESset 
set -U XDG_CONFIG_HOME $HOME/.config

set -U XDG_DATA_HOME $HOME/.local/share

set -U XDG_CACHE_HOME $HOME/.cache

### EXPORT XMONAD DIR
set -U XMONAD_CONFIG_DIR $HOME/.config/xmonad

set -U XMONAD_DATA_DIR $HOME/.local/share/xmonad

set -U XMONAD_CACHE_DIR $HOME/.cache/xmonad


### editor
alias e='helix'

alias hx='helix'

### COMMON
alias l='ls'

alias ll='ls -lh'

alias lla='ls -lah'

alias cp='cp -i'

alias mv='mv -i'

alias rm='rm -i'

alias cls='clear'

alias psa="ps auxf"

alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

alias psmem='ps auxf | sort -nr -k 4'

alias pscpu='ps auxf | sort -nr -k 3'

### MOVE
alias ..='cd ..'

alias ...='cd ../..'

alias .3='cd ../../..'

alias .4='cd ../../../../'

alias .5='cd ../../../../../'

### PACMAN & YAY
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs

alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs

alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)

alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)

alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)

alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)

alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock

alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages

### UPDATEMIRRORLIST
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
