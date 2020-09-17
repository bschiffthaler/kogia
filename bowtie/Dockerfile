ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-bowtie
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG BOWTIE_VERSION=1.3.0
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-dev zlib-static
WORKDIR /build
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/${BOWTIE_VERSION}/bowtie-${BOWTIE_VERSION}-src.zip/download \
    -O bowtie-${BOWTIE_VERSION}-src.zip
RUN unzip bowtie-${BOWTIE_VERSION}-src.zip
WORKDIR /build/bowtie-${BOWTIE_VERSION}-src
RUN make -j${BUILD_NCPU} NO_TBB=1 EXTRA_CFLAGS=-static LDFLAGS=-static
RUN strip *-l *-s

FROM alpine:${ALPINE_VERSION} 

ARG BOWTIE_VERSION=1.3.0

WORKDIR / 
RUN apk add --no-cache bash
RUN apk add --no-cache python3
COPY --from=alpine-build-bowtie /build/bowtie-${BOWTIE_VERSION}-src/bowtie-* /usr/local/bin/
COPY --from=alpine-build-bowtie /build/bowtie-${BOWTIE_VERSION}-src/bowtie /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/bowtie"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BOWTIE_VERSION}
