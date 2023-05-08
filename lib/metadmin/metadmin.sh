#!/bin/sh

set -u

MAIN_COLOR='\e[34m'
VERSION_SHORT="0"
VERSION="${VERSION_SHORT}.0.1"
MAF_PS1='\[\e[4m\]maf'"$VERSION_SHORT"'\[\e[0m\]'
PATH="/bin:/usr/bin"
MODULES_PATH="$METADMIN_PREFIX/lib/metadmin/modules"

_log_info() {
	printf '\e[34m\e[1m[*]\e[0m %s\n' "$*"
}

_log_err() {
	printf '\e[31m\e[1m[-]\e[0m %s\n' "$*"
}

_log_warning() {
	printf '\e[33m\e[1m[-]\e[0m %s\n' "$*"
}

banner() {

	printf '\n\e[36m'
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
	printf '\e[0m\n'
	cat <<EOF
  Cybersecurity is like a game of chess. Except the board
  is made of water, the pieces are on fire, and you have no
  idea what the rules are.
  
  - Aristotle

EOF
	printf '\e[0m\n    =[  \e[33mMetadmin v%s \e[0m  ]\n\n' "$VERSION"
}

search() {

	if [ "$#" -ne 1 ]; then
		printf 'Usage: search [expression]\n'
		return 1
	fi

	printf '\n  Name\n  ---\n'

	(
		cd "$MODULES_PATH"
		find . -type f \( -name "*$1*" -o -path "*$1*" \) | sed 's/^.\//  /g'
	)

	printf '\n'
}

use() {
	module="$1"

	. "${MODULES_PATH}/${module}"
	PS1="$MAF_PS1 (\[\e[1m$MAIN_COLOR\]$module\[\e[0m\]) > "
}

_print_var() {
	var_name="$1"
	var_value="$(eval "echo \${$var_name}")"
	printf "%s\t\t%s\n" "$var_name" "$var_value"
}

_reset(){
		PS1="$MAF_PS1 > "
		module=""
		options=""
		unset -f run
}

exit() {
	if [ "$module" != "" ]; then
		_reset
	else
		command exit
	fi
}

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

set() {
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

### INIT ###

_reset

banner

