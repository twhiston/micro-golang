########################################################################################################################
# Lightweight production container for golang apps
# v1.0.0
########################################################################################################################
FROM tomwhiston/micro-golang:base

LABEL maintainer="tom.whiston@gmail.com"

RUN rm -rf /go/*
########################################################################################################################
# Copy in app
########################################################################################################################
ONBUILD COPY --from=builder --chown=1001 /go/bin/app /usr/local/bin/
########################################################################################################################
# Run the application
# The app is arbitrarily called app due to the copy and build commands, which allows us to be generic
########################################################################################################################
USER 1001
CMD ["app"]