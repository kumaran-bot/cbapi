# Build Stage
FROM lacion/alpine-golang-buildimage:1.13 AS build-stage

LABEL app="build-cbapi"
LABEL REPO="https://github.com/kumaran-bot/cbapi"

ENV PROJPATH=/go/src/github.com/kumaran-bot/cbapi

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/kumaran-bot/cbapi
WORKDIR /go/src/github.com/kumaran-bot/cbapi

RUN make build-alpine

# Final Stage
FROM lacion/alpine-base-image:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/kumaran-bot/cbapi"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/cbapi/bin

WORKDIR /opt/cbapi/bin

COPY --from=build-stage /go/src/github.com/kumaran-bot/cbapi/bin/cbapi /opt/cbapi/bin/
RUN chmod +x /opt/cbapi/bin/cbapi

# Create appuser
RUN adduser -D -g '' cbapi
USER cbapi

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/cbapi/bin/cbapi"]
