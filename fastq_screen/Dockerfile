ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-fastq_screen

ARG ALPINE_VERSION=3.12
ARG FASTQ_SCREEN_VERSION=0.14.1

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget https://github.com/StevenWingett/FastQ-Screen/archive/refs/tags/v${FASTQ_SCREEN_VERSION}.tar.gz &&\
    tar -xvf v${FASTQ_SCREEN_VERSION}.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG FASTQ_SCREEN_VERSION=0.14.1

RUN apk add --no-cache bash wget perl perl-gdgraph

WORKDIR / 
COPY --from=alpine-build-fastq_screen /build/FastQ-Screen-${FASTQ_SCREEN_VERSION}/fastq_screen /usr/local/bin/
COPY --from=bschiffthaler/bowtie2 /usr/local/bin/* /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/fastq_screen"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${FASTQ_SCREEN_VERSION}
