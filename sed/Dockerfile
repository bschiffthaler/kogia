ARG ALPINE_VERSION=3.11
# Final exec image
FROM alpine:${ALPINE_VERSION}
ARG SED_VERSION=4.7-r0

WORKDIR / 

RUN apk update --no-cache && apk add --no-cache sed="${SED_VERSION}"

ENTRYPOINT ["sed"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SED_VERSION}
