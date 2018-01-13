FROM alpine:3.7

LABEL maintainer="tom.whiston@gmail.com"

ENV GOROOT=/usr/lib/go \
    GOPATH=/go \
    GOBIN=/go/bin \
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN apk add --no-cache -U libc-dev git go bash cmake make clang && \
    go get -u github.com/golang/dep/cmd/dep && \
    mkdir -p /go/scripts && \
    rm -rf /var/cache/apk/*

COPY scripts /go/scripts

WORKDIR /go/src/app
########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ .
ONBUILD RUN /go/scripts/install.sh