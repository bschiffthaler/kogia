ARG ALPINE_VERSION=3.18.3
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-kraken2

ARG KRAKEN2_VERSION=2.1.3
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base make bash perl zlib-dev
RUN wget https://github.com/DerrickWood/kraken2/archive/v${KRAKEN2_VERSION}.tar.gz
RUN tar -xf v${KRAKEN2_VERSION}.tar.gz
WORKDIR /build/kraken2-${KRAKEN2_VERSION}
RUN ./install_kraken2.sh /usr/local/kraken2

# Final exec image kraken2
FROM alpine:${ALPINE_VERSION}

ARG KRAKEN2_VERSION=2.1.3

WORKDIR /
RUN apk add --no-cache bash
RUN apk add perl libstdc++ libgcc libgomp rsync
COPY --from=alpine-build-kraken2 /usr/local/kraken2 /usr/local/kraken2
RUN mv /usr/local/kraken2/kraken2 /usr/local/bin/
RUN mv /usr/local/kraken2/kraken2-build /usr/local/bin/
COPY rsync_from_ncbi.pl /usr/local/kraken2/rsync_from_ncbi.pl

ENTRYPOINT ["/usr/local/bin/kraken2"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${KRAKEN2_VERSION}
