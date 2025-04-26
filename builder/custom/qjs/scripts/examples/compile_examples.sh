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
    ${script_dir}/../qjsc.sh -o ${binary_file} ${js_file} || exit 1
done
# compile binaries for ext-lib
if [ -d ${script_dir}/ext-lib ]
then
    for js_file in $(ls ${script_dir}/ext-lib/*.js)
    do
        echo "Compiling '${js_file}'..."
        filename="$(basename ${js_file} .js)"
        binary_file="${script_dir}/ext-lib/${filename}"
        ${script_dir}/../qjsc.sh -o ${binary_file} ${js_file} || exit 1
    done
fi
