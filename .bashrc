# ~/.bashrc
# this file gets sourced by ~/.bash_profile

# --------------------------------------------------------------------------- #
# Basic setup
# --------------------------------------------------------------------------- #

# set INPUTRC (so that .inputrc is respected)
export INPUTRC=~/.inputrc

# add various directories to PATH
PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH
export PATH

# --------------------------------------------------------------------------- #
# Prompt setup
# --------------------------------------------------------------------------- #

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${LIGHT_RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^# On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${GREEN}\u@\h ${YELLOW}\w${COLOR_NONE} ${BRANCH}
${PROMPT_SYMBOL} "
}

set_bash_prompt

# --------------------------------------------------------------------------- #
# VirtualEnv wrapper
# --------------------------------------------------------------------------- #
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
source /usr/local/share/python/virtualenvwrapper.sh

# --------------------------------------------------------------------------- #
# Aliases and auto completion
# --------------------------------------------------------------------------- #

alias ll='ls -alhG'
alias l='ls -lhG'

# ssh autocompletion
if [ -f ~/.ssh/config ]; then
	function _ssh_completion() {
	perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
	}

	complete -W "$(_ssh_completion)" ssh deploysshkey
fi

# --------------------------------------------------------------------------- #
# History
# --------------------------------------------------------------------------- #
export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

# --------------------------------------------------------------------------- #
# Applications
# --------------------------------------------------------------------------- #

# Grails
GRAILS_HOME=/opt/grails-1.3.7; export GRAILS_HOME
GRAILS_BIN=$GRAILS_HOME/bin;
PATH=$PATH:$GRAILS_BIN; export PATH

# Maven2
M2_HOME=/opt/apache-maven-2.2.1; export M2_HOME
M2_BIN=M2_HOME/bin;
PATH=$PATH:$M2_BIN; export PATH

# Android SDK
ANDROID_BIN=/opt/android-sdk-mac_x86/tools;
PATH=$PATH:$ANDROID_BIN; export PATH

# MySQL
MYSQL_BIN=/usr/local/mysql-5.5.11-osx10.6-x86_64/bin;
PATH=$PATH:$MYSQL_BIN; export PATH

# Homebrew
HOMEBREW_BIN="$(brew --prefix)/bin"
HOMEBREW_SBIN="$(brew --prefix)/sbin"
PATH=$HOMEBREW_SBIN:$HOMEBREW_BIN:$PATH; export PATH

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
PATH=$PATH:$HOME/.rvm/bin
