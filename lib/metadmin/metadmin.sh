#!/bin/sh

set -u

MAIN_COLOR='\e[34m'
VERSION_SHORT="0"
VERSION="${VERSION_SHORT}.0.1"
MAF_PS1='\[\e[4m\]maf'"$VERSION_SHORT"'\[\e[0m\]'
MODULES_PATH="$METADMIN_PREFIX/lib/metadmin/modules"

_log_info() {
	printf '\e[34m\e[1m[*]\e[0m %s\n' "$*"
}

_log_err() {
	printf '\e[31m\e[1m[-]\e[0m %s\n' "$*"
}

_log_fatal() {
	printf '\e[31m\e[1m[-]\e[0m %s\n' "$*"
	exit 1
}

_log_warning() {
	printf '\e[33m\e[1m[-]\e[0m %s\n' "$*"
}

banner() {
	printf '\e[36m'
	cat <<'EOF'
  
                      _                  _
                     | '-.            .-' |
                     | -. '..\\,.//,.' .- |
                     |   \  \\\||///  /   |
                    /|    )M\/%%%%/\/(  . |\
                   (/\  MM\/%/\||/%\\/MM  /\)
                   (//M   \%\\\%%//%//   M\\)
                 (// M________ /\ ________M \\)
                  (// M\ \(',)|  |(',)/ /M \\) \\\\  
                   (\\ M\.  /,\\//,\  ./M //)
                     / MMmm( \\||// )mmMM \  \\
                      // MMM\\\||///MMM \\ \\
                       \//''\)/||\(/''\\/ \\
                       mrf\\( \oo/ )\\\/\
                            \'-..-'\/\\
                               \\/ \\

EOF
	printf '\e[0m'
	cat <<EOF
  Cybersecurity is like a game of chess. Except the board
  is made of water, the pieces are on fire, and you have no
  idea what the rules are.
  
  - Aristotle

EOF
	printf '\e[0m    =[  \e[33mMetadmin v%s \e[0m  ]\n\n' "$VERSION"
}

search() {

	if [ "$#" -ne 1 ]; then
		printf 'Usage: search [expression]\n'
		return 1
	fi

	printf '\n  Name\n  ---\n'

	(
		cd "$MODULES_PATH"

		# this will
		# 1. find all the files containing the expression
		# 2. remove the ./ from the beginning
		# 3. highlight the search term

		find . -type f \( -name "*$1*" -o -path "*$1*" \) |
			sed 's/^.\//  /g' |
			grep --color=always -e '^' -e "$1"
	)

	printf '\n'
}

_init_module(){
	. "${MODULES_PATH}/${_maf_module}"
	PS1="$MAF_PS1 (\[\e[1m$MAIN_COLOR\]$_maf_module\[\e[0m\]) > "
}

use() {
	_maf_module="$1" mafconsole
}

_print_var() {
	var_name="$1"
	var_value="$(eval "echo \${$var_name}")"
	printf "%s\t\t%s\n" "$var_name" "$var_value"
}

_init_main(){
	banner
	PS1="$MAF_PS1 > "
	_maf_module=""
	options=""
}

#exit() {
#	if [ "$_maf_module" != "" ]; then
#		_reset
#	else
#		command exit
#	fi
#}

options() {
	if [ -z "$options" ]; then
		return
	fi

	printf -- '\nName\t\tCurrent\n'
	printf -- '----\t\t-------\n'

	for o in $options; do
		_print_var "$o"
	done

	printf '\n'
}

_set() {
	var_name="$1"
	var_value="$2"
	eval "${var_name}='${var_value}'"
}

command_not_found_handle() {
	printf '\e[31m\e[1m[-]\e[0m Unknown command: %s\n' "$1"
}

help() {
	cat <<EOF

Placeholder
===========

EOF
}
#
#
### INIT ###

command cd "$METADMIN_PREFIX/lib/metadmin/modules"

alias cd="command_not_found_handle cd"
alias set="_set"

if [ -n "${_maf_module-}" ]; then
	if [ ! -f "$_maf_module" ]; then
		_log_fatal "Failed to load module: $_maf_module"
	fi

	_init_module
	return 0

fi

_init_main

