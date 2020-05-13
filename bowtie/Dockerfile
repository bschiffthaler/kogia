ARG ALPINE_VERSION=3.11

FROM alpine:${ALPINE_VERSION} AS alpine-build-bowtie
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

ARG ALPINE_VERSION=3.11
ARG BOWTIE_VERSION=1.2.3

RUN apk update && apk add build-base wget zlib-dev zlib-static
WORKDIR /build
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/${BOWTIE_VERSION}/bowtie-src-x86_64.zip/download \
    -O bowtie-src-x86_64.zip
RUN unzip bowtie-src-x86_64.zip
WORKDIR /build/bowtie-${BOWTIE_VERSION}
RUN make NO_TBB=1 EXTRA_CFLAGS=-static LDFLAGS=-static
RUN strip bowtie bowtie-*

FROM alpine:${ALPINE_VERSION} 

ARG BOWTIE_VERSION=1.2.3

WORKDIR / 
RUN apk add --no-cache python
COPY --from=alpine-build-bowtie /build/bowtie-${BOWTIE_VERSION}/bowtie-* /usr/local/bin/
COPY --from=alpine-build-bowtie /build/bowtie-${BOWTIE_VERSION}/bowtie /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/bowtie"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BOWTIE_VERSION}
