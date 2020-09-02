ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-bbtools

ARG ALPINE_VERSION=3.12
ARG BBTOOLS_VERSION=38.86

WORKDIR /build
RUN wget https://deac-ams.dl.sourceforge.net/project/bbmap/BBMap_${BBTOOLS_VERSION}.tar.gz
RUN tar -xf BBMap_${BBTOOLS_VERSION}.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG BBTOOLS_VERSION=38.86

RUN apk add --no-cache openjdk11-jre-headless bash

WORKDIR / 
COPY --from=alpine-build-bbtools /build/bbmap /usr/local/bin/bbmap
ENV PATH="/usr/local/bin/bbmap:$PATH"
ENTRYPOINT ["/usr/local/bin/bbmap/bbmap.sh"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BBTOOLS_VERSION}
