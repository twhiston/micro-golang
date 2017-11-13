########################################################################################################################
# Lightweight testing container for golang apps
# v1.0.0
########################################################################################################################
FROM alpine:3.6

MAINTAINER Tom Whiston <tom.whiston@gmail.com>

ENV GOPATH=/go \
    GOBIN=/go/bin \
    PATH=${PATH}:/go/bin:/go

RUN mkdir -p /go/src/app
WORKDIR /go/src/app


########################################################################################################################
# TESTING
# Installing test tools at this point means we increase the speed of ci runs as it only needs to build the final app
# We also leave the things needed to compile go apps in the container, unlike the production container
# as we need these to run the go test app etc....
########################################################################################################################
RUN apk add --no-cache -U libc-dev git go bash cmake make clang && \
    go get github.com/schrej/godacov && \
    go get -u github.com/haya14busa/goverage && \
    go get -v -d -u golang.org/x/tools/cmd/cover && \
    go install golang.org/x/tools/cmd/cover && \
    mv /go/bin/cover /usr/lib/go/pkg/tool/linux_amd64 && \
    go get -v -u github.com/alecthomas/gometalinter && \
    /go/bin/gometalinter --install

########################################################################################################################
# Runtime Scripts
########################################################################################################################
COPY ./scripts /go/scripts
RUN chmod -R +x /go/scripts