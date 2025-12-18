ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS alpine-build-tabix

ARG ALPINE_VERSION=3.22
ARG HTSLIB_VERSION=1.23
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev ncurses-dev ncurses-static curl-static zlib-static bzip2-static \
    nghttp2-static openssl-libs-static brotli-static

WORKDIR /build
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2
RUN tar -xf htslib-${HTSLIB_VERSION}.tar.bz2
WORKDIR /build/htslib-${HTSLIB_VERSION}
RUN ./configure && \
    make -j${BUILD_NCPU}
RUN strip tabix bgzip htsfile

FROM alpine:${ALPINE_VERSION}

ARG HTSLIB_VERSION=1.23

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libbz2 zlib libcurl xz-libs
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/libhts.so /usr/local/lib/
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/htsfile /usr/local/bin/
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/bgzip /usr/local/bin/
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/tabix /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/tabix"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${HTSLIB_VERSION}
