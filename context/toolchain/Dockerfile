########################################################################################################################
# Lightweight production container for golang apps
# v1.0.0
#######################################################################################################################
FROM tomwhiston/micro-golang:base

LABEL maintainer="tom.whiston@gmail.com"

ENV TOOLCHAIN_FILE=/go/toolchain.yml

########################################################################################################################
# Prepare env for app
########################################################################################################################
COPY mgl-tcb /go/src/mgl-tcb
COPY scripts /go/scripts

RUN mkdir -p /go/work && \
    /go/scripts/make-default-entrypoint.sh && \
    rm /go/scripts/make-default-entrypoint.sh
########################################################################################################################
# ONBUILD app install
# This adds go, compiles your app and then uninstalls go again
# This provides the minimum possible runtime image size
########################################################################################################################
ONBUILD COPY ./ /go
ONBUILD RUN apk add --no-cache -U libc-dev git go && \
  /go/scripts/build-toolchain.sh && \
  chown -R 1001:0 /usr/local/bin && \
  chmod -R +x /usr/local/bin && \
  apk del libc-dev git go && \
  rm -rf /var/cache/apk/*

WORKDIR /go/work
########################################################################################################################
# Run the application
# The app is arbitrarily called app due to the copy and build commands, which allows us to be generic
########################################################################################################################
CMD ["/go/scripts/entrypoint.sh"]