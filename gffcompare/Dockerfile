ARG ALPINE_VERSION=3.13
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-gffcompare

ARG ALPINE_VERSION=3.13
ARG GFFC_VERSION=0.12.6
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base make
RUN wget https://github.com/gpertea/gffcompare/releases/download/v${GFFC_VERSION}/gffcompare-${GFFC_VERSION}.tar.gz
RUN tar -xf gffcompare-${GFFC_VERSION}.tar.gz
WORKDIR /build/gffcompare-${GFFC_VERSION}
RUN make -j${BUILD_NCPU} release
RUN strip gffcompare
RUN strip trmap

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG GFFC_VERSION=0.12.6

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-gffcompare /build/gffcompare-${GFFC_VERSION}/gffcompare /usr/local/bin/gffcompare
COPY --from=alpine-build-gffcompare /build/gffcompare-${GFFC_VERSION}/trmap /usr/local/bin/trmap
ENTRYPOINT ["/usr/local/bin/gffcompare"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${GFFC_VERSION}
