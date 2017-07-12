#!/bin/bash

set -e

CONSUL_HOST=${CONSUL_HOST:-localhost}
CONSUL_PORT=${CONSUL_PORT:-8500}

putValue() {
    local file=$1
    if [[ -z ${file} ]]; then
        echo "${FUNCNAME}(): No file parameter provided." 1>&2
        exit 1
    fi
    if [[ ${file} == ./* ]]; then
        file=${file:2} # remove "./" prefix if present
    fi
    key=${file%.yml} # remove .yml suffix
    echo -e "Putting \e[1;37m${file}\e[0m into consul key/value store ..."
    curl --silent --fail -X PUT --data-binary @${f} ${CONSUL_HOST}:8500/v1/kv/${key} > /dev/null
}

files=
if [[ -z $@ ]]; then
    echo -e "No files passed as arguments. Selecting all data.yml"
    files=$(find . -name 'data.yml')
else
    files=$@
fi

for f in ${files}
do
    putValue ${f}
done
