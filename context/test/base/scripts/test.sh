#!/usr/bin/env bash

set -e

scriptExit() {
    rv=$?

    if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_EXIT}" ]; then
        echo "---> Running exit script"
        # shellcheck source=/dev/null
        source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_EXIT}" $rv
    fi

    if [[ -n ${CODACY_TOKEN+x} ]]; then
        echo "---> Export Test Coverage to Codacy"
        godacov -t "${CODACY_TOKEN}" -r ./coverage.out -c "${COMMIT_ID}"
    fi

    echo "---> Tests Complete"
    exit $rv
}
trap "scriptExit" INT TERM EXIT

if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_INSTALL}" ]; then
    echo "---> Running pre-install script"
    # shellcheck source=/dev/null
    source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_INSTALL}"
fi

if [[ "$MGL_INSTALL" == "true" ]]; then
    echo "---> Installing Application"
    if [ -e Gopkg.lock ]; then
        echo "---> Using dep ensure"
        dep ensure
    else
        echo "---> Using go get"
        go get -v -t app
    fi
fi

if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_RUN}" ]; then
    echo "---> Running pre-run script"
    # shellcheck source=/dev/null
    source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_PRE_RUN}"
fi

if [[ "${MGL_TEST}" == "true" ]]; then
    echo "---> Run Golang Tests"
    goverage -v -coverprofile=coverage.out ./...
fi

if [[ "${MGL_LINT}" == "true" ]]; then
    echo "---> Run Gometalinter"
    if [ -f "${MGL_CONFIG_PATH}/${MGL_LINT_CONFIG}" ]; then
	    echo "Using project configuration file"
	    gometalinter --disable-all --config "${MGL_CONFIG_PATH}/${MGL_LINT_CONFIG}" ./...
    else
	    gometalinter --vendor ./...
    fi
fi

if [ -f "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_RUN}" ]; then
    echo "---> Running post-run script"
    # shellcheck source=/dev/null
    source "${MGL_CONFIG_PATH}/${MGL_SCRIPT_POST_RUN}"
fi