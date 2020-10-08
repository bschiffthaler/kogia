ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION} AS alpine-build-kallisto

ARG ALPINE_VERSION=3.12
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

ARG KALLISTO_VERSION=0.46.2
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget hdf5-dev hdf5-static curl-dev \
    curl-static zlib-dev zlib-static cmake autoconf libcurl make autoconf automake

WORKDIR /build

ADD kallisto-${KALLISTO_VERSION}-alpine-${ALPINE_VERSION}.patch .

RUN wget https://github.com/pachterlab/kallisto/archive/v${KALLISTO_VERSION}.tar.gz && \
    tar -xf v${KALLISTO_VERSION}.tar.gz && \
    cp -r kallisto-${KALLISTO_VERSION}  kallisto-${KALLISTO_VERSION}_new && \
    patch -p0 < kallisto-${KALLISTO_VERSION}-alpine-${ALPINE_VERSION}.patch

WORKDIR /build/kallisto-${KALLISTO_VERSION}/ext/htslib

RUN autoreconf && autoconf 

WORKDIR /build/kallisto-${KALLISTO_VERSION}/build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DUSE_HDF5=ON .. && make -j${BUILD_NCPU}
RUN strip src/kallisto

FROM alpine:${ALPINE_VERSION}

ARG KALLISTO_VERSION=0.46.2

WORKDIR / 
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-kallisto /build/kallisto-${KALLISTO_VERSION}/build/src/kallisto /usr/local/bin/kallisto
ENTRYPOINT ["/usr/local/bin/kallisto"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${KALLISTO_VERSION}
