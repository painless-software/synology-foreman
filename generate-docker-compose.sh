#!/bin/sh

[ "$1" = "" ] && {
    echo "Download and customize docker-compose.yml from The Foreman project."
    echo
    echo "Usage: $0 <domain>"
    exit 1
}

wget -q -O- https://raw.githubusercontent.com/theforeman/foreman/develop/docker-compose.yml | \
sed "s/example\.com/$1/g" \
> docker-compose.yml
