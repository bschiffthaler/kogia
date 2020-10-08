ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-bcftools
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG BCFTOOLS_VERSION=1.11
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-dev tar bzip2-dev xz-dev \
    curl-dev curl-static zlib-static bzip2-static openssl-libs-static  \
    nghttp2-static brotli-static

WORKDIR /build
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2
RUN tar -xf bcftools-${BCFTOOLS_VERSION}.tar.bz2
WORKDIR /build/bcftools-${BCFTOOLS_VERSION}
RUN ./configure --prefix=/build/inst && make -j${BUILD_NCPU} && make install
RUN strip /build/inst/bin/bcftools
RUN for n in /build/inst/libexec/bcftools/*.so; do strip $n; done


FROM alpine:${ALPINE_VERSION}

ARG BCFTOOLS_VERSION=1.11

RUN apk add --no-cache bash
RUN apk add --no-cache libbz2 zlib libcurl xz-libs

WORKDIR / 
COPY --from=alpine-build-bcftools /build/inst/bin/bcftools /usr/local/bin/bcftools
COPY --from=alpine-build-bcftools /build/inst/libexec/bcftools /usr/local/libexec/bcftools
ENTRYPOINT ["/usr/local/bin/bcftools"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BCFTOOLS_VERSION}
