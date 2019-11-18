FROM alpine AS alpine-build-fastqc
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip && \
    unzip fastqc_v0.11.8.zip && \
    chmod +x FastQC/fastqc

FROM alpine 
WORKDIR / 
RUN apk update && apk add --no-cache openjdk8-jre-base perl
COPY --from=alpine-build-fastqc /build/FastQC /usr/local/bin/FastQC
ENTRYPOINT ["/usr/local/bin/FastQC/fastqc"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='0.11.8'