#!/bin/bash
set -e

APT_PACKAGES=<<EOF
vim \
wget \
open-ssh
EOF

APT_GUI_PACKAGES=<<EOF
vlc \
wine \
texlive \
cairo-dock \
build-essential \
clang \
clojure \
python3 \
ipython3 \
ruby \
haskell-platform
EOF

case $OSTYPE in
    darwin*)
        # Install homebrew
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        BREW=1
        ;;
    linux*)
        which apt-get && APTGET=1
        which dnf && DNF=1
        ;;
esac

if [ $APTGET ]
then
    if [ $(whoami) != "root" ]
    then
        echo "Please run as root"
        exit
    fi
    apt-get update
    apt-get install $APT_PACKAGES
    apt-get upgrade
elif [ $BREW ]
then
    if [ $(whoami) == "root" ]
    then
        echo "Install homebrew as a normal user"
        exit
    fi
    brew update
    brew install $BREW_PACKAGES
    brew upgrade
elif [ $DNF ]
then
    if [ $(whoami) != "root" ]
    then
        echo "Please run as root"
        exit
    fi
    dnf update
    dnf install $DNF_PACKAGES
    dnf upgrade
fi
