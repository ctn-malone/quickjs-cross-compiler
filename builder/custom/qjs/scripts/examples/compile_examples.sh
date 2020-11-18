#!/bin/sh

###
#
# Compile all .js sources in this directory
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
# compile binaries
for js_file in $(ls ${script_dir}/*.js)
do
    echo "Compiling '${js_file}'..."
    filename="$(basename ${js_file} .js)"
    binary_file="${script_dir}/${filename}"
    # add bignum extension if needed
    bignum_flag=""
    if [ ${filename} = "pi_bigdecimal" ] || \
       [ ${filename} = "pi_bigfloat" ] || \
       [ ${filename} = "pi_bigfloat" ]
    then
        bignum_flag="-fbignum"
    fi
    ${script_dir}/../qjsc.sh ${bignum_flag} -o ${binary_file} ${js_file} || exit 1
done
