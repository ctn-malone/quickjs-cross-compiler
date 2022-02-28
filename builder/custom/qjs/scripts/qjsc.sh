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

# if variable is not defined yet, check if upx is available
if [ -z ${QJS_UPX} ]
then
    upx=$(which upx)
    if ! [ -z ${upx} ]
    then
        QJS_UPX=1
    fi
fi
script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
QJS_UPX=${QJS_UPX} ${script_dir}/qjsc "$@"
