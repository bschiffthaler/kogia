FROM alpine AS alpine-build-samtools
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG SAMTOOLS_VERSION=1.10

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev ncurses-dev ncurses-static curl-static zlib-static bzip2-static \
    nghttp2-static openssl-libs-static

WORKDIR /build
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN tar -xf samtools-${SAMTOOLS_VERSION}.tar.bz2
WORKDIR /build/samtools-${SAMTOOLS_VERSION}
RUN ./configure && \
    make CFLAGS="-g -O2 -static" \
    LIBS="-lssl -lcrypto -lnghttp2 -lcurl" \
    LDFLAGS="-static"

FROM alpine 

ARG SAMTOOLS_VERSION=1.10

WORKDIR / 
COPY --from=alpine-build-samtools /build/samtools-${SAMTOOLS_VERSION}/samtools /usr/local/bin/samtools
ENTRYPOINT ["/usr/local/bin/samtools"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SAMTOOLS_VERSION}
