ARG ALPINE_VERSION=3.18.3

FROM alpine:${ALPINE_VERSION} AS alpine-build-fastqc
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG FASTQC_VERSION=0.12.1

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip && \
    unzip fastqc_v${FASTQC_VERSION}.zip && \
    chmod +x FastQC/fastqc

FROM alpine:${ALPINE_VERSION}

ARG FASTQC_VERSION=0.12.1

RUN apk add --no-cache bash

WORKDIR /
RUN apk add --no-cache openjdk8-jre fontconfig ttf-dejavu perl
COPY --from=alpine-build-fastqc /build/FastQC /usr/local/bin
ENTRYPOINT ["/usr/local/bin/fastqc"]

#ENV PATH=/usr/local/bin/FastQC:$PATH

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${FASTQC_VERSION}
