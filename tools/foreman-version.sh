#!/bin/sh -e
#
# Compute latest stable version and image tag from image registry.

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

FOREMAN_LATEST_VERSION=$(echo $FOREMAN_LATEST_STABLE | sed 's/-stable//')
