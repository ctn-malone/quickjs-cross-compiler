#!/usr/bin/env bash

###
#
# Fetch dependencies
# - download musl sources
# - download musl-based cross compiler (see https://github.com/ctn-malone/musl-cross-maker)
# - create symlinks under the root directory ofr musl-cc compiler to maje compilation process easier
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([deps-dir],[d],[directory where dependencies should be stored/built],[$script_dir/../../deps])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([force],[f],[force re-fetching dependencies],[off])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Fetch dependencies needed to build a static version of QuickJS])
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

# validators

arch()
{
	local _allowed=("x86_64" "i686" "armv7l" "aarch64") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'x86_64', 'i686', 'armv7l' and 'aarch64'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='dafvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_deps_dir="$script_dir/../../deps"
_arg_arch="x86_64"
_arg_force="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Fetch dependencies needed to build a static version of QuickJS"
	printf 'Usage: %s [-d|--deps-dir <arg>] [-a|--arch <type string>] [-f|--(no-)force] [-v|--(no-)verbose] [-h|--help]\n' "$0"
	printf '\t%s\n' "-d, --deps-dir: directory where dependencies should be stored/built (default: '$script_dir/../../deps')"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "-f, --force, --no-force: force re-fetching dependencies (off by default)"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-d|--deps-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_deps_dir="$2"
				shift
				;;
			--deps-dir=*)
				_arg_deps_dir="${_key##--deps-dir=}"
				;;
			-d*)
				_arg_deps_dir="${_key##-d}"
				;;
			-a|--arch)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_arch="$(arch "$2" "arch")" || exit 1
				shift
				;;
			--arch=*)
				_arg_arch="$(arch "${_key##--arch=}" "arch")" || exit 1
				;;
			-a*)
				_arg_arch="$(arch "${_key##-a}" "arch")" || exit 1
				;;
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
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash
# Validation of values


### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv
source "${script_dir}/../env/deps"

# Fetch 'musl-cc' tarball, decompress & create symlink under ${deps_dir}
fetch_musl_cc()
{
    [ ${_arg_verbose} == "on" ] && echo "Downloading 'musl-cc' for '${_arg_arch}'..."

    case ${_arg_arch} in
        x86_64)
            declare -n _cfg="cfg_musl_cc_x86_64"
            ;;
        i686)
            declare -n _cfg="cfg_musl_cc_i686"
            ;;
        armv7l)
            declare -n _cfg="cfg_musl_cc_armv7l"
            ;;
        aarch64)
            declare -n _cfg="cfg_musl_cc_aarch64"
            ;;
    esac

    # directory which will contain 'musl-cc' files after decompression
    _archive_dir="${archives_dir}/${_cfg["archive_dir"]}"
    # location of the archive file after download
    _archive=${archives_dir}/$(basename "${_cfg["archive_url"]}")
    # symlink under 'deps' directory, referencing the directory containing 'musl-cc' files
    _archive_dir_symlink=${deps_dir}/${_cfg["archive_dir_symlink"]}
    # compiler's target (ex: x86_64-linux-musl)
    _machine=$(echo "${_cfg["archive_dir"]}" | sed 's/-cross.*//')
    # symlinks created at the root of the directory containing 'musl_cc' files
    _cc_symlink=${_archive_dir}/cc
    _strip_symlink=${_archive_dir}/strip
    _libatomic_symlink=${_archive_dir}/libatomic.a
    _libssp_nonshared_symlink=${_archive_dir}/libssp_nonshared.a

    # dependency already fetched & decompressed
    if [ -d ${_archive_dir} ] && [ ${_arg_force} == "off" ]
    then
        [ ${_arg_verbose} == "on" ] && echo "No need to download 'musl-cc' for '${_arg_arch}'"
    else
        # fetch tarball & decompress
        (rm -fr ${_archive_dir} && \
            wget -O ${_archive} ${_cfg["archive_url"]} && \
            tar -C ${archives_dir} -xzf ${_archive}) || return 1
        [ ${_arg_verbose} == "on" ] && echo "Successfully downloaded 'musl-cc' for '${_arg_arch}'"
    fi

    # create symlink to archive directory
    (rm -f ${_archive_dir_symlink} &&
        ln -s "$(basename ${archives_dir})/${_cfg["archive_dir"]}" ${_archive_dir_symlink}) || return 1

    # create symlink to 'cc' binary
    (rm -f ${_cc_symlink} &&
        ln -s "bin/${_machine}-cc" ${_cc_symlink}) || return 1

    # create symlink to 'strip' binary
    (rm -f ${_strip_symlink} &&
        ln -s "bin/${_machine}-strip" ${_strip_symlink}) || return 1

    # create symlink to 'libatomic' static library
    (rm -f ${_libatomic_symlink} &&
        ln -s "${_machine}/lib/libatomic.a" ${_libatomic_symlink}) || return 1

    # create symlink to 'libssp_nonshared' static library
    (rm -f ${_libssp_nonshared_symlink} &&
        ln -s "${_machine}/lib/libssp_nonshared.a" ${_libssp_nonshared_symlink}) || return 1

    return 0
}

# Fetch 'musl lib' tarball, decompress & create symlink under ${deps_dir}
fetch_musl_lib()
{
    [ ${_arg_verbose} == "on" ] && echo "Downloading 'musl lib'..."

    declare -n _cfg="cfg_musl_lib"

    # directory which will contain 'musl' sources after decompression
    _archive_dir="${archives_dir}/${_cfg["archive_dir"]}"
    # location of the archive file after download
    _archive=${archives_dir}/$(basename "${_cfg["archive_url"]}")
    # symlink under 'deps' directory, referencing the directory containing 'musl-cc' sources
    _archive_dir_symlink=${deps_dir}/${_cfg["archive_dir_symlink"]}

    # dependency already fetched & decompressed
    if [ -d ${_archive_dir} ] && [ ${_arg_force} == "off" ]
    then
        [ ${_arg_verbose} == "on" ] && echo "No need to download 'musl lib'"
    else
        # fetch tarball & decompress
        (rm -fr ${_archive_dir} && \
            wget -O ${_archive} ${_cfg["archive_url"]} && \
            tar -C ${archives_dir} -xzf ${_archive}) || return 1
        [ ${_arg_verbose} == "on" ] && echo "Successfully downloaded 'musl lib'"
    fi

    # create symlink to archive directory
    (rm -f ${_archive_dir_symlink} &&
        ln -s "$(basename ${archives_dir})/${_cfg["archive_dir"]}" ${_archive_dir_symlink}) || return 1

    return 0
}

# fetch all dependencies
fetch_deps()
{
    [ ${_arg_verbose} == "on" ] && echo "Fetching dependencies for '${_arg_arch}'..."

    fetch_musl_lib || return 1
    fetch_musl_cc || return 1

    [ ${_arg_verbose} == "on" ] && echo "Dependencies for '${_arg_arch}' successfully fetched"

    return 0
}

_PRINT_HELP=no
deps_dir=${_arg_deps_dir}
# directory where archives will be downloaded
archives_dir=${deps_dir}/archives

mkdir -p ${archives_dir}

fetch_deps || die "Could not fetch dependencies"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
