#!/bin/ash
# shellcheck shell=dash

echo "---> Installing Application"
if [ -e Gopkg.lock ]; then
    echo "---> Using dep ensure"
    /go/bin/dep ensure
    go install
else
    echo "---> Using go get"
    go get -v -t app
fi