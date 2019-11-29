FROM alpine AS alpine-build-bedtools
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG BEDTOOLS_VERSION=2.29.0

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev curl-static zlib-static bzip2-static openssl-libs-static  \
    nghttp2-static python bash

WORKDIR /build

RUN wget https://github.com/arq5x/bedtools2/archive/v${BEDTOOLS_VERSION}.tar.gz && \
    tar -xf v${BEDTOOLS_VERSION}.tar.gz

WORKDIR /build/bedtools2-${BEDTOOLS_VERSION}

RUN make BT_CXXFLAGS='-static -O2' BT_LDFLAGS='-static'

FROM alpine 
WORKDIR / 
COPY --from=alpine-build-bedtools /build/bedtools2-${BEDTOOLS_VERSION}/bin/bedtools /usr/local/bin/bedtools
ENTRYPOINT ["/usr/local/bin/bedtools"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BEDTOOLS_VERSION}