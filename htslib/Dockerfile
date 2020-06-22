ARG ALPINE_VERSION=3.11

FROM alpine:${ALPINE_VERSION} AS alpine-build-tabix
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.11
ARG HTSLIB_VERSION=1.10.2

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev ncurses-dev ncurses-static curl-static zlib-static bzip2-static \
    nghttp2-static openssl-libs-static

WORKDIR /build
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2
RUN tar -xf htslib-${HTSLIB_VERSION}.tar.bz2
WORKDIR /build/htslib-${HTSLIB_VERSION}
RUN ./configure && \
    make CFLAGS="-g -O2 -static" \
    LIBS="-lcurl -lssl -lcrypto -lnghttp2 -lz -lbz2 -llzma" \
    LDFLAGS="-static"
RUN strip tabix bgzip htsfile

FROM alpine:${ALPINE_VERSION}

ARG HTSLIB_VERSION=1.10.2

WORKDIR / 
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/htsfile /usr/local/bin/
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/bgzip /usr/local/bin/
COPY --from=alpine-build-tabix /build/htslib-${HTSLIB_VERSION}/tabix /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/tabix"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${HTSLIB_VERSION}
