#!/bin/ash
# shellcheck shell=dash

set -e

echo "---> Installing Toolchain"

echo "---> Compile Toolchain Builder"
cd /go/src/mgl-tcb && go get ./... && go install

echo "---> Run Toolchain Builder"
/go/bin/mgl-tcb -f ${TOOLCHAIN_FILE}

echo "---> Cleaning Up"
rm /go/bin/mgl-tcb
rm /go/toolchain.yml

echo "---> Toolchain Installed"