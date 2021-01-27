# from http://labo.bio.kyutech.ac.jp/~kohanada/Softwares.htm
ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-sorffinder

ARG ALPINE_VERSION=3.12
ARG SOF_VERSION=2

RUN apk update && apk add wget

WORKDIR /build

RUN wget http://labo.bio.kyutech.ac.jp/~kohanada/sORFfinder${SOF_VERSION}.tar.gz
RUN tar -xvf sORFfinder${SOF_VERSION}.tar.gz
RUN chmod +x sORFfinder${SOF_VERSION}/src/*.pl

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG SOF_VERSION=2

WORKDIR /
RUN apk add --no-cache bash
COPY --from=alpine-build-sorffinder /build/sORFfinder${SOF_VERSION}/src/*.pl /usr/local/bin/
COPY --from=bschiffthaler/ncbi-blast:latest /usr/local/bin/tblastn /usr/local/bin/tblastn
COPY --from=bschiffthaler/clustalw:latest /usr/local/bin/clustalw2 /usr/local/bin/clustalw2

ENTRYPOINT ["/usr/local/bin/make_model.pl"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${SOF_VERSION}
