#!/bin/bash
CONSUL_HOST=$1
if [[ "${CONSUL_HOST}" == "" ]]; then
    echo -e "Warning: No consul host parameter provided. Using localhost.\n" 1>&2
    CONSUL_HOST=localhost
fi
scriptdir="$( cd "$( dirname "$0" )" && pwd )"

cat > /tmp/git2consul.json <<EOF
{
  "version": "1.0",
  "repos" : [{
    "include_branch_name" : false,
    "expand_keys" : false,
    "name" : "scs-poc-config",
    "url" : "file://${scriptdir}",
    "source_root": "scs-poc-config",
    "ignore_file_extension" : true,
    "branches" : ["master"],
    "no_daemon": true
  }]
}
EOF

if ! which npm >/dev/null 2>&1; then
    echo "npm not found. Please install npm first" 1>&2
    exit 1
fi
if [[ ! -f ${scriptdir}/node_modules/.bin/git2consul ]]; then
    echo "git2consul not found. Installing locally" 1>&2
    npm install git2consul
fi

${scriptdir}/node_modules/.bin/git2consul --endpoint ${CONSUL_HOST} --port 8500 --config-file /tmp/git2consul.json
