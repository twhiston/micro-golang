FROM alpine:3.7

LABEL maintainer="tom.whiston@gmail.com"

RUN apk add --no-cache -U libc-dev git go bash cmake make clang && \
    rm -rf /var/cache/apk/*

WORKDIR /go/src/app
########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ .
ONBUILD RUN go get -v app