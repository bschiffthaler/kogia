ARG ALPINE_VERSION=3.14

FROM alpine:${ALPINE_VERSION} AS alpine-build-bowtie

ARG ALPINE_VERSION=3.14
ARG BOWTIE_VERSION=2.4.5
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-dev zlib-static
WORKDIR /build
RUN wget https://github.com/BenLangmead/bowtie2/archive/refs/tags/v${BOWTIE_VERSION}.tar.gz
RUN tar -xvf v${BOWTIE_VERSION}.tar.gz
WORKDIR /build/bowtie2-${BOWTIE_VERSION}
RUN make -j${BUILD_NCPU} NO_TBB=1 EXTRA_CFLAGS=-static LDFLAGS=-static
RUN strip *-l *-s

FROM alpine:${ALPINE_VERSION} 

ARG BOWTIE_VERSION=2.4.5

WORKDIR / 
RUN apk add --no-cache bash
RUN apk add --no-cache perl python3
COPY --from=alpine-build-bowtie /build/bowtie2-${BOWTIE_VERSION}/bowtie2-* /usr/local/bin/
COPY --from=alpine-build-bowtie /build/bowtie2-${BOWTIE_VERSION}/bowtie2 /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/bowtie2"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BOWTIE_VERSION}
