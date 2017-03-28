parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}

parse_git_dirty() {
  if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]]; then
    echo '\[\e[01;31m\]\342\234\227'
  else
    echo '\[\e[01;32m\]\342\234\223'
  fi
}

set_prompt () {
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    PS1="\n"
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\\h"
    else
        PS1+="$Blue\\u"
    fi

    PS1+="$White in "

    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Green\\w"
    if [ -n "$(parse_git_branch)" ]; then
      PS1+="$White on "
      PS1+="$Blue$(parse_git_branch)"
      PS1+="$(parse_git_dirty)"
    else
      PS1+=" "
    fi
    PS1+="\n$Red\\\$$Reset "
}
PROMPT_COMMAND='set_prompt'

##########
# Alises #
##########

# I can't be bothered to type the extra n each time
alias vim=nvim
alias view="nvim +\"set readonly\""

# Should probably be using python 3.x by now...
alias python=python3
alias pip=pip3

# Make ls nice
alias ls='ls -Gp'
alias ll='ls -l'
alias la='ls -a'

# Prevent Oh $#!7 moments
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Cool little scripts
alias imgcat="${HOME}/.scripts/imgcat.sh"     # Display images inline
alias weather="${HOME}/.scripts/ansiweather"  # Display weather at input location
alias welcome="${HOME}/.scripts/welcome.sh"   # Display information on startup

#############
# Functions #
#############

function mcd () {    #make and cd
  mkdir -p $1
  cd $1
}

function extract {  #universal extract
  if [ -z "$1"  ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1  ] ; then
      # NAME=${1%.*}
      # mkdir $NAME && cd $NAME
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.lzma)      unlzma $1      ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar x -ad $1 ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.xz)        unxz ../$1        ;;
        *.exe)       cabextract ../$1  ;;
        *)           echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}
