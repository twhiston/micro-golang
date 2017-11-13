########################################################################################################################
# Lightweight testing container for golang apps
# This onbuild variant is useful for ci's that like a docker file in the project or to perform a build
# v1.0.0
########################################################################################################################
FROM tomwhiston/micro-golang:test

MAINTAINER Tom Whiston <tom.whiston@gmail.com>


ENV MGL_INSTALL=false

ONBUILD COPY ./ /go/src/app
ONBUILD RUN go get -v -t app

CMD ["/go/scripts/test.sh"]