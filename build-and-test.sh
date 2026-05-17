#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

ansible-builder build -vvv -t test:$1
ansible-navigator run --execution-environment-image test:$1 --pull-policy missing  play.yml