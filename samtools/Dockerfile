ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS alpine-build-samtools

ARG ALPINE_VERSION=3.13
ARG SAMTOOLS_VERSION=1.23
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev ncurses-dev ncurses-static curl-static zlib-static bzip2-static \
    nghttp2-static openssl-libs-static brotli-static

WORKDIR /build
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN tar -xf samtools-${SAMTOOLS_VERSION}.tar.bz2
WORKDIR /build/samtools-${SAMTOOLS_VERSION}
RUN ./configure && \
    make -j${BUILD_NCPU}
RUN strip samtools

FROM alpine:${ALPINE_VERSION}

ARG SAMTOOLS_VERSION=1.23

RUN apk add --no-cache bash
RUN apk add --no-cache libbz2 zlib libcurl xz-libs
WORKDIR /
COPY --from=alpine-build-samtools /build/samtools-${SAMTOOLS_VERSION}/samtools /usr/local/bin/samtools
ENTRYPOINT ["/usr/local/bin/samtools"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SAMTOOLS_VERSION}
