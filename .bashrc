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
# Aliases and auto completion
# --------------------------------------------------------------------------- #

alias ll='ls -alh --group-directories-first'
alias l='ls -lh --group-directories-first'

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