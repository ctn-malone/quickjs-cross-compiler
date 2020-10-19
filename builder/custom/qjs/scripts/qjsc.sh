#!/bin/sh

###
#
# This script should be use if you want to symlink 'qjsc' binary
# When using a direct symlink, compilation will fail since 'qjsc'
# won't be able to find includes & libraries
#
# Using an intermediate shell script ensure symlink is correctly
# resolved 
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
${script_dir}/qjsc "$@"
