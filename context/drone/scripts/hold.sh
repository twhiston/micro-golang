#!/usr/bin/env bash

echo "Run ./cleanup.sh when you are done to allow container to finish."

pushd /tmp
    echo "rm .jet.lock ; echo Waiting for shutdown..." > ./cleanup.sh
    chmod +x cleanup.sh

    touch .jet.lock

    # check the lock file every five seconds.
    while [ -f ".jet.lock" ]
    do
        sleep 5
    done
popd

echo "Cleaning up."