FROM alpine AS alpine-build-fastqc
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG FASTQC_VERSION=0.11.8

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip && \
    unzip fastqc_v${FASTQC_VERSION}.zip && \
    chmod +x FastQC/fastqc

FROM alpine 

ARG FASTQC_VERSION=0.11.8

WORKDIR / 
RUN apk update && apk add --no-cache openjdk8-jre fontconfig ttf-dejavu perl
COPY --from=alpine-build-fastqc /build/FastQC /usr/local/bin/FastQC
ENTRYPOINT ["/usr/local/bin/FastQC/fastqc"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${FASTQC_VERSION}