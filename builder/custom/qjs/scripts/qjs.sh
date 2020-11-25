#!/bin/sh

###
#
# This script should be use if you want to symlink 'qjs' binary
# When using a direct symlink, import of js files located in the
# directory containing 'qjs' binary will fail since 'qjs' binary
# won't be able to find includes & libraries
#
# Using an intermediate shell script ensure symlink is correctly
# resolved
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
${script_dir}/qjs "$@"
