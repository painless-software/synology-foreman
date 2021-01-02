#!/bin/sh

[ "$1" = "" ] && {
    echo "Download and customize docker-compose.yml from The Foreman project."
    echo
    echo "Usage: $0 <domain>"
    exit 1
}

which wget > /dev/null || {
    echo 'wget is required. Install it e.g. via `sudo apt install wget`'
    exit 2
}

which jq > /dev/null || {
    echo 'jq is required. See https://stedolan.github.io/jq/ for installation instructions.'
    exit 3
}

FOREMAN_LATEST_STABLE=$(wget -q -O- https://quay.io/api/v1/repository/foreman/foreman | \
        jq '.tags | to_entries[] | .key' | grep stable | sort | tail -n1 | sed 's/"//g')

wget -q -O- https://raw.githubusercontent.com/theforeman/foreman/develop/docker-compose.yml | \
sed -E \
    -e "s%^(version: .*)$%# The Foreman Docker Compose setup. Generated by:\n# $0\ $1\n\n\1%" \
    -e "s/ (image: .*):develop$/ \1:$FOREMAN_LATEST_STABLE/g" \
    -e "s/example\.com/$1/g" \
    -e "/ build:/d" \
    -e "/ context: \./d" \
> docker-compose.yml
