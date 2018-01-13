########################################################################################################################
# Lightweight production container for golang apps
# v1.0.0
########################################################################################################################
FROM alpine:3.7

LABEL maintainer="tom.whiston@gmail.com"

ENV GOROOT=/usr/lib/go \
    GOPATH=/go \
    GOBIN=/go/bin \
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin

########################################################################################################################
# Prepare env for app
########################################################################################################################
RUN mkdir -p /go/src/app && \
    mkdir -p /go/scripts && \
    adduser -u 1001 -G root -h /go -D nonroot

WORKDIR /go/src/app
COPY scripts /go/scripts

########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ /go/src/app
ONBUILD RUN apk add --no-cache -U libc-dev git go && \
  go get -u github.com/golang/dep/cmd/dep && \
  /go/scripts/install.sh && \
  mv /go/bin/app /usr/local/bin/ && \
  chown 1001:0 /usr/local/bin/app && \
  apk del libc-dev git go && \
  rm -rf /go/* && \
  rm -rf /var/cache/apk/*

########################################################################################################################
# Run the application
# The app is arbitrarily called app due to the copy and build commands, which allows us to be generic
########################################################################################################################
CMD ["app"]