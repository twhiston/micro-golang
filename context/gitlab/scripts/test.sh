#!/usr/bin/env bash

echo "---> Installing App"
go get -v -t app

echo "---> Run Golang Tests"
/go/bin/goverage -v -coverprofile=coverage.out ./...

echo "---> Run MetaLinter Tests"
/go/bin/gometalinter --exclude \w*_test\w* ./...
