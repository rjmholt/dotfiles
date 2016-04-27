#!/bin/bash

# Set the old *shudder* emacs screen clear shortcut
alias ='clear'

# Some useful 'ls' aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lg='ls -Glh'

# Add an "alert" alias for long running commands. e.g.
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Move around easily
# cd now lists contents of a directory when moving in
#cd() { builtin cd "$@"; ll; }
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# Some useful garden-variety aliases
alias mkdir='mkdir -p'
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias h='history'
alias path='echo -e ${PATH//:/\\n}' 
alias numfiles='echo $(ls -1 | wc -l)'
case $OSTYPE in
  darwin*)
    alias which='type -a' ;;
esac

# Make a new dir and go inside
mcd () { mkdir -p "$1" && cd "$1"; }

# Move a file to directory and go with it
take () { mv "$1" "$2" && cd "$2"; }

# Probably unwise in some way, but otherwise 'reboot' is just an
# alias for an error message.
alias reboot='sudo reboot'

# Join the modern era
#alias python='python3.4'

# Vim masterrace 4 lyfe
case $OSTYPE in
  darwin*)
    alias vim='/usr/local/bin/vim' ;;
esac
alias vi="vim"
alias cim='vim'
alias ivm='vim'
alias edit='vim'
alias emacs='vim' # Mwahahaha
#alias subl='vim'
alias :q='echo "Not in vim..."'
alias :wq='echo "Not in vim..."'
alias :q!='echo "Not in vim..."'
# A nice eclimd shortcut
alias start_eclimd='~/Applications/eclipse/eclimd &>/dev/null &'

# Use the Frege compiler 'natively'
alias fregec='java -Xss1m -jar fregec.jar -d build'

# Make work easy to get to
GA=~/Documents/GeneralAssembly
UNI=~/Documents/Uni/2016S1
unicd () {
  UNIPATH=$(readlink -f $UNI)
  case $1 in
    pli) cd $UNIPATH/Programming_Language_Implementation_COMP90045;;
    smod) cd $UNIPATH/Software_Modelling_and_Design_SWEN30006;;
    sra) cd $UNIPATH/Software_Requirements_Analysis_SWEN90009;;
    da) cd $UNIPATH/Distributed_Algorithms_COMP90020;;
    *)
      echo "Error: Invalid argument"
      echo "Valid subjects are:"
      echo -e "\tsmod -> Software Modelling and Design"
      echo -e "\tpli  -> Programming Language Implementation"
      echo -e "\tsra  -> Software Requirements Analysis"
      echo -e "\tda   -> Distributed Algorithms"
  esac
}

# Define an intellij alias
alias intellij='nohup ~/Applications/idea-IU-145.597.3/bin/idea.sh &>/dev/null &'

# Define words nicely, and pronounce them first
define () {
  # Speak the word aloud and write its phonetic rendition
  echo "Phoneme mnemonics: $(espeak -ven-uk-rp -s 120 "$1" 2> /dev/null)"
  dict "$1" | less
}

# Search man page for $1 with $2 highlighted
mans () {
  man $1 | grep -iC2 --color=always $2 | less
}

# Remind myself of an alias
#showa () {
#  /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash |
#  grep -v '^\s*$' |
#  less -FSRXc
#}

# Zip a file
zipf () {
  zip -r "$1".zip "$1"
}

# Extract most known archives
extract () {
  if [[ -f $1 ]] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1    ;;
      *.tar.gz)   tar xzf $1    ;;
      *.bz2)      bunzip2 $1    ;;
      *.rar)      unrar e $1    ;;
      *.gz)       gunzip $1     ;;
      *.tar)      tar xf $1     ;;
      *.tbz2)     tar xjf $1    ;;
      *.tgz)      tar xzf $1    ;;
      *.zip)      unzip $1      ;;
      *.Z)        uncompress $1 ;;
      *.7z)       7z x $1       ;;
      *)    echo "'$1' cannot be extracted by extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Search stuff
alias qfind='find . -name '
ff () { /usr/bin/find . -name "$@" ; }
ffs () { /usr/bin/find . -name "$@"'*' ; }
ffe () { /usr/bin/find . -name '*'"$@" ; }

# Spotlight search
case $OSTYPE in
  darwin*)
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc" ; } ;;
esac

# -----------------------------
# PROCESS MANAGEMENT
# -----------------------------

# Find the pid of a process. Regex works too.
case $OSTYPE in
  darwin*)
    findPid () { lsof -r -c "$@" ; } ;;
esac

# Find memory hogs
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# Find CPU hogs
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time.command | head -10'

# Continual 'top' listing (every 10 seconds)
alias topForever='top -l 9999999 -s 10 -o cpu'

# 'top' invocation to minimise resource usage
alias ttop='top -R -F -s 10 -o rsize'

# List processes owned by my user
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


# -----------------------------
# NETWORK STUFF
# -----------------------------

# My public IP address
alias myip='curl ip.appspot.com'
# Show all open TCP/IP sockets
case $OSTYPE in
  darwin*)
    alias netCons='lsof -i'
    # Flush the DNS cache
    alias flushDNS='dscacheutil -flushcache'
    # Display open sockets
    alias lsock='sudo /usr/sbin/lsof -i -P'
    # Display only open UDP sockets
    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'
    # Display only open TCP sockets
    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'
    # Info for connections over en0
    alias ipInfo0='ipconfig getpacket en0'
    # Info for connections over en1
    alias ipInfo1='ipconfig getpacket en1'
    # All listening connections
    alias openPorts='sudo lsof -i | grep LISTEN'
    # All ipfw rules including blocked IPs
    alias showBlocked='sudo ipfw list'
    ;;
esac

# Show useful host related information
ii () {
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditional information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date:$NC " ; date
  echo -e "\n${RED}Machine stats:$NC " ; uptime
  echo -e "\n${RED}Current network location:$NC " ; scselect
  echo -e "\n${RED}Public facing IP Address:$NC " ; myip
  echo -e "\n${RED}DNS Configuration:$NC" ; scutil --dns
  echo
}

# -----------------------------
# Mac OSX Specific Commands
# 
# Mainly file system organisation stuff
# -----------------------------

case $OSTYPE in
  darwin*)
    # Put something in the Trash
    trash () { command mv "$@" ~/.Trash ; }
    # Open in the OSX Quicklook Preview
    ql () { qlmanage -p "$*" >& /dev/null; }
    # Pipe terminal output to a file too
    alias DT='tee ~/Desktop/terminalOut.txt'

    # Clean up DS Store files
    alias cleanupDS="find . -type -f -name '*.DS_Store' -ls -delete"

    # Make hidden folders appear/disappear in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

    # Clean up LaunchServices to remove duplicates in the 'Open With' menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"
    ;;
esac

case $OSTYPE in
  *linux*)
    alias netreset='sudo service network-manager restart'
    ;;
esac
