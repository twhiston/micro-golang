#!/usr/bin/env bash

echo "Run /go/scripts/cleanup.sh when you are done to allow container to finish."

pushd /tmp
    echo "rm .mgl.lock ; echo Waiting for shutdown..." > /go/scripts/cleanup.sh
    chmod +x /go/scripts/cleanup.sh

    touch .mgl.lock

    # check the lock file every five seconds.
    while [ -f ".mgl.lock" ]
    do
        sleep 5
    done
popd

echo "Cleaning up."