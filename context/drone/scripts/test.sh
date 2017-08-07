#!/usr/bin/env bash

go test -v -cover ./...
/go/bin/gometalinter --exclude \w*_test\w*
