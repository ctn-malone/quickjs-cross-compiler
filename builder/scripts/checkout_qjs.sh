#!/usr/bin/env bash

###
#
# Checkout a specific version of QuickJS from github
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_BOOLEAN([force],[f],[clone repository even if it exists],[off])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_POSITIONAL_SINGLE([qjs-version],[QuickJS version (ex: 2020-09-06)],[$default_qjs_version])
# ARG_HELP([Clone QuickJS repository & checkout a specific commit])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='fvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_qjs_version="$default_qjs_version"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_force="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Clone QuickJS repository & checkout a specific commit"
	printf 'Usage: %s [-f|--(no-)force] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]\n' "$0"
	printf '\t%s\n' "<qjs-version>: QuickJS version (ex: 2020-09-06) (default: '$default_qjs_version')"
	printf '\t%s\n' "-f, --force, --no-force: clone repository even if it exists (off by default)"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-f|--no-force|--force)
				_arg_force="on"
				test "${1:0:5}" = "--no-" && _arg_force="off"
				;;
			-f*)
				_arg_force="on"
				_next="${_key##-f}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-f" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-v|--no-verbose|--verbose)
				_arg_verbose="on"
				test "${1:0:5}" = "--no-" && _arg_verbose="off"
				;;
			-v*)
				_arg_verbose="on"
				_next="${_key##-v}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 1, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_qjs_version "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

# ensure version exist
qjs_commit="${qjs_commits[${_arg_qjs_version}]}"
if [ -z ${qjs_commit} ]
then
    _PRINT_HELP=yes die "QuickJS version '${_arg_qjs_version}' is not supported"
fi

# clone QuickJS repo
clone_repo()
{
    [ ${_arg_verbose} == "on" ] && echo "Cloning 'QuickJS' repository '${qjs_repository}'..."

    # no need to clone repository
    if [ -d ${repo_dir} ] && [ ${_arg_force} == "off" ]
    then
        [ ${_arg_verbose} == "on" ] && echo "No need to clone 'QuickJS' repository '${qjs_repository}'"
    else
        (rm -fr ${repo_dir} && \
            cd ${script_dir}/.. &&
            git clone ${qjs_repository} ${repo_dir}) || return 1
        [ ${_arg_verbose} == "on" ] && echo "Successfully cloned 'QuickJS' repository '$qjs_repository'"
    fi

    return 0
}

# Checkout a specific commit corresponding to the requested version
checkout_commit()
{
    [ ${_arg_verbose} == "on" ] && echo "Checking out 'QuickJS' commit '${qjs_commits[${_arg_qjs_version}]}'..."

    (cd ${repo_dir} &&
        git checkout ${qjs_commits[${_arg_qjs_version}]}) || return 1

    [ ${_arg_verbose} == "on" ] && echo "Successfully checked out 'QuickJS' commit '${qjs_commits[${_arg_qjs_version}]}'"

    return 0
}

_PRINT_HELP=no
src_dir="${script_dir}/../src"
repo_dir="${script_dir}/../../quickjs-repo"

clone_repo || die "Could not clone repository"
checkout_commit || die "Could not checkout commit"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
