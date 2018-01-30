#!/bin/ash
# shellcheck shell=dash

FILE=/go/toolchain.txt

/bin/cat <<EOM >${FILE}
    Micro-golang toolchain builder

    Use this image as a base for your toolchains
EOM