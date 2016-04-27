BASH_PATH=~/.bash

if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

# OPAM configuration
. /home/rob/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
