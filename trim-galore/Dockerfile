ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-trim-galore
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG TRIM_GALORE_VERSION=0.6.5

RUN apk update && apk add wget

WORKDIR /build

RUN wget https://github.com/FelixKrueger/TrimGalore/archive/${TRIM_GALORE_VERSION}.tar.gz
RUN tar -xvf ${TRIM_GALORE_VERSION}.tar.gz

FROM bschiffthaler/fastqc:latest

ARG TRIM_GALORE_VERSION=0.6.5

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache pigz
COPY --from=alpine-build-trim-galore /build/TrimGalore-${TRIM_GALORE_VERSION}/trim_galore /usr/local/bin/trim_galore
COPY --from=bschiffthaler/cutadapt:latest /usr/local/bin/cutadapt /usr/local/bin/cutadapt

ENV PATH=/usr/local/bin/FastQC:$PATH

ENTRYPOINT ["/usr/local/bin/trim_galore"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${TRIM_GALORE_VERSION}
