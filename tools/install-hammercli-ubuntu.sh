#!/bin/sh -e
#
# Install hammer-cli locally for database initialization tasks.

. $(dirname $0)/foreman-version.sh

echo "deb [arch=amd64] http://deb.theforeman.org/ $(lsb_release -cs) ${FOREMAN_LATEST_VERSION}" \
  | sudo tee /etc/apt/sources.list.d/foreman.list

wget -q https://deb.theforeman.org/foreman.asc -O- | sudo apt-key add -

sudo apt-get update
sudo apt-get install ruby-hammer-cli-foreman
