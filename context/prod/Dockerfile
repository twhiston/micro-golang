########################################################################################################################
# Lightweight production container for golang apps
# v1.0.0
########################################################################################################################
FROM alpine:3.6

MAINTAINER Tom Whiston <tom.whiston@gmail.com>

ENV GOROOT=/usr/lib/go \
    GOPATH=/go \
    GOBIN=/go/bin \
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin

########################################################################################################################
# Prepare env for app
########################################################################################################################
RUN mkdir -p /go/src/app
WORKDIR /go/src/app

########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ /go/src/app
ONBUILD RUN apk add --no-cache -U libc-dev git go && \
  go get -v app && \
  apk del libc-dev git go && \
  rm -rf /go/pkg && \
  rm -rf /go/src && \
  rm -rf /var/cache/apk/*

########################################################################################################################
# Run the application
# The app is arbitrarily called app due to the copy and build commands, which allows us to be generic
########################################################################################################################
ENTRYPOINT ["/go/bin/app"]