#!/bin/bash

CONSUL=
if which consul >/dev/null 2>&1; then
    echo "Found consul in path"
    CONSUL=consul
elif [[ -x ./consul ]]; then
    echo "Found consul in working dir"
    CONSUL="./consul"
else
    echo "No consul found in path. Starting download ..."
    VERSION=0.7.1
    OS=
    case "${OSTYPE}" in
        linux*)   OS=linux ;;
        darwin*)  OS=darwin ;;
    esac
    CONSUL_ZIP_URL="https://releases.hashicorp.com/consul/${VERSION}/consul_${VERSION}_${OS}_amd64.zip"
    TARGET_FILE=/tmp/consul.zip
    if which wget >/dev/null 2>&1; then
        wget ${CONSUL_ZIP_URL} -O ${TARGET_FILE} || exit 2
    elif which curl >/dev/null 2>&1; then
        curl -o ${TARGET_FILE} ${CONSUL_ZIP_URL} || exit 2
    else
        echo "wget nor curl found. Can not download consul.zip from remote web server." 1>&2
        exit 1
    fi
    unzip /tmp/consul.zip || exit 3
    CONSUL="./consul"
fi

if [[ -d /tmp/scs-poc-config ]]; then
    echo "Deleting existing /tmp/scs-poc-config dir"
    rm -rf /tmp/scs-poc-config
fi

echo -e "Run \e[1;36m./dev-git2consul.sh\e[0m or \e[1;36m./dev-data.yml2consul.sh\e[0m after startup to populate the key value store\n"

${CONSUL} agent -dev -ui "$@"
