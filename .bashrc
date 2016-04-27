#!/bin/bash

# Do nothing if running interactively
case $- in
  *i*) ;;
  *) return ;;
esac

# Source global definitions
if [[ -f /etc/bashrc ]]; then
  . /etc/bashrc
fi

## PATH additions
# Add homebrew to the path for OSX
case $OSTYPE in
  darwin*)
    PATH="/usr/local/bin/:${PATH}"
    PATH="${PATH}"
    export PATH ;;
esac

# Let opam set configure the PATH for OCaml
eval $(opam config env)

# Add recent GHC for Ubuntu and cabal
PATH="/opt/cabal/1.22/bin:${PATH}"
#PATH="/opt/ghc/7.10.3/bin:${PATH}"
PATH="~/.local/bin:${PATH}"

# Add erlang libaries
export ERL_LIBS="~/.erl_libs/jiffy"

# Add JS linting for vim -- currently installed globally...
#PATH="$(npm bin):${PATH}"

if [[ -x /usr/bin/lesspipe ]]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

if [[ -x /usr/bin/dircolors ]]; then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)"

  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

#if ! shopt -oq posix; then
#  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
#    . /usr/share/bash_completion/bash_completion
#  elif [[ -f /etc/bash_completion ]]; then
#    . /etc/bash_completion
#  fi
#fi

if [[ -f ~/.git-completion.bash ]]; then
  . ~/.git-completion.bash
fi

case $OSTYPE in
  linux*)
    if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
      debian_chroot=$(cat /etc/debian_chroot)
    fi
    shopt -s globstar ;;
esac

case $OSTYPE in
  darwin*)
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    ;;
esac

# Set $DISPLAY if not already set
function get_xserver ()
{
  case $TERM in
    xterm*)
      XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
      XSERVER=${XSERVER%%:0}
      ;;
  esac
}

if [[ -z ${DISPLAY:=""} ]]; then
  get_xserver
  if [[ -z ${XSERVER} || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
    DISPLAY="0:0"           # Display on local host
  else
    DISPLAY=${XSERVER}:0.0  # Display on remote host
  fi
fi

export DISPLAY

# ----------------------------------------------------------------------
# Some useful settings
# ----------------------------------------------------------------------

ulimit -S -c 0
set -o notify
set -o noclobber
set -o ignoreeof

# Vim masterrace!
export EDITOR=vim
set -o vi
alias ='clear'

# Enable options
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob

# Disable options
shopt -u mailwarn
unset MAILCHECK     # Shell will not warn of incoming mail

# ----------------------------------------------------------------------
# Greeting, motd, etc...
# ----------------------------------------------------------------------

# Colours
case $OSTYPE in
  darwin*)
    # Normal Colors
    Black=$'\e[0;30m'        # Black
    Red=$'\e[0;31m'          # Red
    Green=$'\e[0;32m'        # Green
    Yellow=$'\e[0;33m'       # Yellow
    Blue=$'\e[0;34m'         # Blue
    Purple=$'\e[0;35m'       # Purple
    Cyan=$'\e[0;36m'         # Cyan
    White=$'\e[0;37m'        # White

    # Bold
    BBlack=$'\e[1;30m'       # Black
    BRed=$'\e[1;31m'         # Red
    BGreen=$'\e[1;32m'       # Green
    BYellow=$'\e[1;33m'      # Yellow
    BBlue=$'\e[1;34m'        # Blue
    BPurple=$'\e[1;35m'      # Purple
    BCyan=$'\e[1;36m'        # Cyan
    BWhite=$'\e[1;37m'       # White

    # Background
    On_Black=$'\e[40m'       # Black
    On_Red=$'\e[41m'         # Red
    On_Green=$'\e[42m'       # Green
    On_Yellow=$'\e[43m'      # Yellow
    On_Blue=$'\e[44m'        # Blue
    On_Purple=$'\e[45m'      # Purple
    On_Cyan=$'\e[46m'        # Cyan
    On_White=$'\e[47m'       # White

    NC=$'\e[m'               # Color Reset

    ALERT=${BWhite}${On_Red} # Bold White on red background
    ;;
  linux*)
    # Normal Colors
    Black='\e[0;30m'        # Black
    Red='\e[0;31m'          # Red
    Green='\e[0;32m'        # Green
    Yellow='\e[0;33m'       # Yellow
    Blue='\e[0;34m'         # Blue
    Purple='\e[0;35m'       # Purple
    Cyan='\e[0;36m'         # Cyan
    White='\e[0;37m'        # White

    # Bold
    BBlack='\e[1;30m'       # Black
    BRed='\e[1;31m'         # Red
    BGreen='\e[1;32m'       # Green
    BYellow='\e[1;33m'      # Yellow
    BBlue='\e[1;34m'        # Blue
    BPurple='\e[1;35m'      # Purple
    BCyan='\e[1;36m'        # Cyan
    BWhite='\e[1;37m'       # White

    # Background
    On_Black='\e[40m'       # Black
    On_Red='\e[41m'         # Red
    On_Green='\e[42m'       # Green
    On_Yellow='\e[43m'      # Yellow
    On_Blue='\e[44m'        # Blue
    On_Purple='\e[45m'      # Purple
    On_Cyan='\e[46m'        # Cyan
    On_White='\e[47m'       # White

    NC="\e[m"               # Color Reset

    ALERT=${BWhite}${On_Red} # Bold White on red background
    ;;
esac

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
  - DISPLAY on ${BRed}$DISPLAY${NC}\n"
date
echo -e "\n"
echo -e "${BRed}Hello, Dave. You're looking well today.${NC}\n"
if [[ -x /usr/games/fortune ]]; then
  if [[ -x /usr/games/cowsay ]]; then
    fortune -s | cowsay
  else
    /usr/games/fortune -s
  fi
elif [[ -x /usr/local/bin/fortune ]]; then
  /usr/local/bin/fortune -s
fi

function _exit ()
{
  echo -e "${BRed}Logging you out, Shepard...${NC}"
}
trap _exit EXIT


#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit en
#    so it's available to all shells (using 'history -a').

# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" && $OSTYPE != darwin* ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(whoami) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

case $OSTYPE in
  linux*)
    NCPU=$(grep -c 'processor' /proc/cpuinfo) ;; # Number of CPUs
  darwin*)
    NCPU=$(sysctl -n hw.ncpu) ;;
esac
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# Returns system load as a percentage
function load()
{
  case $OSTYPE in
    linux*)
      local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
      # System load of the current host
      echo $((10#$SYSLOAD)) ;;   # Convert to decimal
    darwin*)
      local SYSLOAD=$(sysctl -n vm.loadavg | cut -d " " -f2 | tr -d '.')
      echo $SYSLOAD ;;
  esac
}


# Returns a color indicating system load.
function load_color()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${BRed}
    else
        echo -en ${Green}
    fi
}

# Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                   awk 'END {print $5} {sub(/%/,"")}')
        case $OSTYPE in
          darwin*)
            used=${used%"%"} ;;
        esac

        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${BRed}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${BCyan}
    fi
}

# Adds some text in the terminal frame (if applicable).


# Now we construct the prompt.
PROMPT_COMMAND="history -a"
case ${TERM} in
  *term | *term-256color | rxvt | linux)
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # Time of day (with load info):
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # PWD (with 'disk space' info):
        PS1=${PS1}"\[\$(disk_color)\]\W]\[${NC}\] "
        # Prompt (with 'job' info):
        PS1=${PS1}"\[\$(job_color)\]\[${NC}\]"
        # User@Host (with connection type info):
        PS1=${PS1}"\n\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] $ "
        # Set title of current xterm:
        PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
        ;;
    *)
        PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                               # --> Shows full pathname of current dir.
        ;;
esac

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts

case $OSTYPE in
  linux*)
    #-------------------------------------------------------------
    # Make the following commands run in background automatically:
    #-------------------------------------------------------------

    function te()  # wrapper around xemacs/gnuserv
    {
        if [ "$(gnuclient -batch -eval t 2>&-)" == "t" ]; then
           gnuclient -q "$@";
        else
           ( xemacs "$@" &);
        fi
    }

    function soffice() { command soffice "$@" & }
    function firefox() { command firefox "$@" & }
    function xpdf() { command xpdf "$@" & }


    #-------------------------------------------------------------
    # File & strings related functions:
    #-------------------------------------------------------------


    # Find a file with a pattern in name:
    function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

    # Find a file with pattern $1 in name and Execute $2 on it:
    function fe() { find . -type f -iname '*'"${1:-}"'*' \
    -exec ${2:-file} {} \;  ; }

    #  Find a pattern in a set of files and highlight them:
    #+ (needs a recent version of egrep).
    function fstr()
    {
        OPTIND=1
        local mycase=""
        local usage="fstr: find string in files.
    Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
        while getopts :it opt
        do
            case "$opt" in
               i) mycase="-i " ;;
               *) echo "$usage"; return ;;
            esac
        done
        shift $(( $OPTIND - 1 ))
        if [ "$#" -lt 1 ]; then
            echo "$usage"
            return;
        fi
        find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

    }


    function swap()
    { # Swap 2 filenames around, if they exist (from Uzi's bashrc).
        local TMPFILE=tmp.$$

        [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
        [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
        [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

        mv "$1" $TMPFILE
        mv "$2" "$1"
        mv $TMPFILE "$2"
    }

    function extract()      # Handy Extract Program
    {
        if [ -f $1 ] ; then
            case $1 in
                *.tar.bz2)   tar xvjf $1     ;;
                *.tar.gz)    tar xvzf $1     ;;
                *.bz2)       bunzip2 $1      ;;
                *.rar)       unrar x $1      ;;
                *.gz)        gunzip $1       ;;
                *.tar)       tar xvf $1      ;;
                *.tbz2)      tar xvjf $1     ;;
                *.tgz)       tar xvzf $1     ;;
                *.zip)       unzip $1        ;;
                *.Z)         uncompress $1   ;;
                *.7z)        7z x $1         ;;
                *)           echo "'$1' cannot be extracted via >extract<" ;;
            esac
        else
            echo "'$1' is not a valid file!"
        fi
    }


    # Creates an archive (*.tar.gz) from given directory.
    function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

    # Create a ZIP archive of a file or folder.
    function makezip() { zip -r "${1%%/}.zip" "$1" ; }

    # Make your directories and files access rights sane.
    function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

    #-------------------------------------------------------------
    # Process/system related functions:
    #-------------------------------------------------------------


    function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
    function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


    function killps()   # kill by process name
    {
        local pid pname sig="-TERM"   # default signal
        if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
            echo "Usage: killps [-SIGNAL] pattern"
            return;
        fi
        if [ $# = 2 ]; then sig=$1 ; fi
        for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
        do
            pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
            if ask "Kill process $pid <$pname> with signal $sig?"
                then kill $sig $pid
            fi
        done
    }

    function mydf()         # Pretty-print of 'df' output.
    {                       # Inspired by 'dfc' utility.
        for fs ; do

            if [ ! -d $fs ]
            then
              echo -e $fs" :No such file or directory" ; continue
            fi

            local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
            local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
            local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
            local out="["
            for ((j=0;j<20;j++)); do
                if [ ${j} -lt ${nbstars} ]; then
                   out=$out"*"
                else
                   out=$out"-"
                fi
            done
            out=${info[2]}" "$out"] ("$free" free on "$fs")"
            echo -e $out
        done
    }


    function my_ip() # Get IP adress on ethernet.
    {
        MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
          sed -e s/addr://)
        echo ${MY_IP:-"Not connected"}
    }

    function ii()   # Get current host related info.
    {
        echo -e "\nYou are logged on ${BRed}$HOST"
        echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
        echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
                 cut -d " " -f1 | sort | uniq
        echo -e "\n${BRed}Current date :$NC " ; date
        echo -e "\n${BRed}Machine stats :$NC " ; uptime
        echo -e "\n${BRed}Memory stats :$NC " ; free
        echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
        echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
        echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
        echo
    }


    #-------------------------------------------------------------
    # Misc utilities:
    #-------------------------------------------------------------

    function repeat()       # Repeat n times command.
    {
        local i max
        max=$1; shift;
        for ((i=1; i <= max ; i++)); do  # --> C-like syntax
            eval "$@";
        done
    }


    function ask()          # See 'killps' for example of use.
    {
        echo -n "$@" '[y/n] ' ; read ans
        case "$ans" in
            y*|Y*) return 0 ;;
            *) return 1 ;;
        esac
    }

    function corename()   # Get name of app that created a corefile.
    {
        for file ; do
            echo -n $file : ; gdb --core=$file --batch | head -1
        done
    }
    ;;
esac

# Import own aliases
if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
