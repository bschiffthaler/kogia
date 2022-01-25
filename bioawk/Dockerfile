ARG ALPINE_VERSION=3.13
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-bioawk

ARG ALPINE_VERSION=3.13
ARG BIOAWK_VERSION=1.0
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar zlib-static byacc
RUN wget https://github.com/lh3/bioawk/archive/refs/tags/v${BIOAWK_VERSION}.tar.gz
RUN tar -xf v${BIOAWK_VERSION}.tar.gz
WORKDIR /build/bioawk-${BIOAWK_VERSION}
RUN make -j${BUILD_NCPU}
RUN strip bioawk

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG BIOAWK_VERSION=1.0

RUN apk add --no-cache bash

WORKDIR / 
COPY --from=alpine-build-bioawk /build/bioawk-${BIOAWK_VERSION}/bioawk /usr/local/bin/bioawk
ENTRYPOINT ["/usr/local/bin/bioawk"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BIOAWK_VERSION}
