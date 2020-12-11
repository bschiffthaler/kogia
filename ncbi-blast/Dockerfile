ARG ALPINE_VERSION=3.12

# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-blast

ARG ALPINE_VERSION=3.12
ARG BLAST_VERSION=2.11.0
ARG BUILD_NCPU=1

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
WORKDIR /build
RUN apk update && apk add build-base lapack-dev libc6-compat libexecinfo-dev curl-dev libssh-dev zlib-dev wget
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-src.tar.gz
RUN tar -xvf ncbi-blast-${BLAST_VERSION}+-src.tar.gz
RUN cp -r ncbi-blast-${BLAST_VERSION}+-src ncbi-blast-${BLAST_VERSION}+-src_new
COPY ncbi-blast-${BLAST_VERSION}-alpine-${ALPINE_VERSION}.patch ncbi-blast-${BLAST_VERSION}-alpine-${ALPINE_VERSION}.patch
RUN patch -p0 < ncbi-blast-${BLAST_VERSION}-alpine-${ALPINE_VERSION}.patch
WORKDIR /build/ncbi-blast-${BLAST_VERSION}+-src/c++
RUN ./configure --with-dll --without-gui --without-caution --with-64 --without-debug --with-bincopy --with-openmp
RUN make -j${BUILD_NCPU} LIBS='-lexecinfo -lz' CXXFLAGS='-Wno-cpp -fPIC' CFLAGS='-fPIC'

RUN mkdir /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finalbin
RUN mkdir /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finallib

COPY libs.txt /build/libs.txt
COPY execs.txt /build/execs.txt

RUN cp /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/lib/*.so /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finallib
RUN while read l; do cp /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/bin/${l} /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finalbin; done < /build/execs.txt

RUN strip /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finalbin/*
RUN strip /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finallib/*.so

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG BLAST_VERSION=2.11.0

WORKDIR /

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories

RUN apk add --no-cache bash
RUN apk add --no-cache libc6-compat libexecinfo libgcc libstdc++

COPY --from=alpine-build-blast /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finalbin/*  /usr/local/bin/
COPY --from=alpine-build-blast /build/ncbi-blast-${BLAST_VERSION}+-src/c++/ReleaseMT/finallib/*.so /usr/local/lib/

ENTRYPOINT ["/usr/local/bin/blastn"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BLAST_VERSION}
