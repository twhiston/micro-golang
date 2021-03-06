########################################################################################################################
# Lightweight testing container for golang apps
# v1.0.0
########################################################################################################################
FROM tomwhiston/micro-golang:base

LABEL maintainer="tom.whiston@gmail.com"

ENV MGL_INSTALL=true \
    MGL_TEST=true \
    MGL_LINT=true \
    MGL_LINT_CONFIG="gometalinter.json" \
    MGL_SCRIPT_PRE_RUN="pre-run" \
    MGL_SCRIPT_POST_RUN="post-run" \
    MGL_SCRIPT_EXIT="exit"

########################################################################################################################
# TESTING
# Installing test tools at this point means we increase the speed of ci runs as it only needs to build the final app
# We also leave the things needed to compile go apps in the container, unlike the production container
# as we need these to run the go test app etc....
# cover must be put in place manually on alpine as it does not install directly in the tools dir
########################################################################################################################
RUN apk add --no-cache -U libc-dev git go bash cmake make clang && \
    go get github.com/schrej/godacov && \
    go get -u github.com/haya14busa/goverage && \
    go get -u github.com/golang/dep/cmd/dep && \
    go get -v -d -u golang.org/x/tools/cmd/cover && \
    go install golang.org/x/tools/cmd/cover && \
    mv "${GOBIN}/cover" /usr/lib/go/pkg/tool/linux_amd64 && \
    go get -v -u github.com/alecthomas/gometalinter && \
    "${GOBIN}/gometalinter" --install --update

########################################################################################################################
# Runtime Scripts
########################################################################################################################
COPY ./scripts /go/scripts
RUN chmod -R +x /go/scripts

#Our test script is run in this instance
#You could override this with /go/scripts/hold.sh to hold the container open for debug
CMD ["/go/scripts/test.sh"]