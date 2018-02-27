#!/bin/ash
# shellcheck shell=dash

if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_INSTALL}" ]; then
    echo "---> Running pre-install script"
    # shellcheck source=/dev/null
    source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_INSTALL}"
fi

echo "---> Installing Application"
if [ -e Gopkg.lock ]; then
    echo "---> Using dep ensure"
    /go/bin/dep ensure
    if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_DEPS}" ]; then
        echo "---> Running post-deps script"
        # shellcheck source=/dev/null
        source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_DEPS}"
    fi
    go install
else
    echo "---> Using go get"
    go get -v app
fi

if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_INSTALL}" ]; then
    echo "---> Running post-install script"
    # shellcheck source=/dev/null
    source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_INSTALL}"
fi