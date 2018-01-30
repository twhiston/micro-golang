########################################################################################################################
# Lightweight testing container for golang apps
# This onbuild variant is useful for ci's that like a docker file in the project or to perform a build
# Note that the dependencies are installed as part of the test scripts,
# if you want to add them here copy them in and set MGL_INSTALL=false
# v1.0.0
########################################################################################################################
FROM tomwhiston/micro-golang:test-base

LABEL maintainer="tom.whiston@gmail.com"

ONBUILD COPY ./ /go/src/app

CMD ["/go/scripts/test.sh"]