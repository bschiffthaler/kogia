ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-bwa

ARG ALPINE_VERSION=3.12
ARG BWA_VERSION=0.7.17
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar zlib-static
RUN wget https://github.com/lh3/bwa/releases/download/v${BWA_VERSION}/bwa-${BWA_VERSION}.tar.bz2
RUN tar -xf bwa-${BWA_VERSION}.tar.bz2
WORKDIR /build/bwa-${BWA_VERSION}
RUN make -j${BUILD_NCPU} CFLAGS="-static -g -Wall -Wno-unused-function -O2"
RUN strip bwa

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG BWA_VERSION=0.7.17

RUN apk add --no-cache bash

WORKDIR / 
COPY --from=alpine-build-bwa /build/bwa-${BWA_VERSION}/bwa /usr/local/bin/bwa
ENTRYPOINT ["/usr/local/bin/bwa"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BWA_VERSION}
