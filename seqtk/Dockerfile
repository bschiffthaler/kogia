ARG ALPINE_VERSION=3.14
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-seqtk

ARG ALPINE_VERSION=3.14
ARG SEQTK_VERSION=1.3

WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar zlib-static
RUN wget https://github.com/lh3/seqtk/archive/refs/tags/v${SEQTK_VERSION}.tar.gz
RUN tar -zxf v${SEQTK_VERSION}.tar.gz
WORKDIR /build/seqtk-${SEQTK_VERSION}
# somehow running make fails, but there is only one file to compile
RUN gcc -g -Wall -O2 -Wno-unused-function seqtk.c -o seqtk -lz -lm
RUN strip seqtk

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG SEQTK_VERSION=1.3

RUN apk add --no-cache bash

WORKDIR /
COPY --from=alpine-build-seqtk /build/seqtk-${SEQTK_VERSION}/seqtk /usr/local/bin/seqtk
ENTRYPOINT ["/usr/local/bin/seqtk"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SEQTK_VERSION}
