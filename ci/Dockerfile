FROM alpine:3.7

ARG ARCH="x86_64"
ARG DOCKER_CHANNEL=edge
ARG DOCKER_VERSION=17.11.0-ce
ARG GOSS_VERSION=v0.3.5

ENV GOSS_PATH=/usr/local/bin/goss \
    GOPATH=/go \
    GOBIN=/go/bin
   #PATH must be in a seperate env command so that previous ENV values exist
ENV PATH=$GOBIN:$PATH:/usr/local/bin

RUN apk add --no-cache -U libc-dev git go curl bash && \
    go get -u -v github.com/go-task/task/cmd/task && \
    mkdir -p /root/.docker/ && \
    mkdir -p /root/src/ && \
    curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${ARCH}/docker-${DOCKER_VERSION}.tgz" && \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/ && \
    rm docker.tgz && \
    curl -fL -o /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/"${GOSS_VERSION}"/goss-linux-amd64 && \
    curl -fL -o /usr/local/bin/dgoss https://raw.githubusercontent.com/aelsabbahy/goss/"${GOSS_VERSION}"/extras/dgoss/dgoss  && \
    chmod +rx /usr/local/bin/goss && \
    chmod +rx /usr/local/bin/dgoss

COPY bin/* /usr/local/bin/
WORKDIR /root/src
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]