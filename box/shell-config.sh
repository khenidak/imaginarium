#!/bin/bash

set -x
set -o pipefail

if [[ ! -z "${SHELL_CONFIG_DONE}" ]]; then
	# Append to history don't overwrite it
	export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
	export HISTSIZE=100000                   # big big history
	export HISTFILESIZE=100000               # big big history
	shopt -s histappend                      


	## we run ssh agent 
	## and add all dev boxes keys
	## by default
	eval $(ssh-agent)
	#TODO: make this configurable
	#ssh-add ~/keys/xclusters #load xclusters key by default

	# configure PS1 the right way
	export PS1="${PS1:0:($((${#PS1}-3)))}\n$ "

else
	echo "this shell has been previously configured"
fi



