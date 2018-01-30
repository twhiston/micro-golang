FROM tomwhiston/micro-golang:base

LABEL maintainer="tom.whiston@gmail.com"

RUN apk add --no-cache -U libc-dev git go bash cmake make clang && \
    go get -u github.com/golang/dep/cmd/dep && \
    rm -rf /var/cache/apk/*

COPY scripts /go/scripts
########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ .
ONBUILD RUN /go/scripts/install.sh