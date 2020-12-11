ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-gffread

ARG ALPINE_VERSION=3.12
ARG GFFR_VERSION=0.12.4
ARG BUILD_NCPU=1

RUN apk update && apk add build-base make

WORKDIR /build
RUN wget https://github.com/gpertea/gffread/releases/download/v${GFFR_VERSION}/gffread-${GFFR_VERSION}.tar.gz
RUN tar -xf gffread-${GFFR_VERSION}.tar.gz
WORKDIR gffread-${GFFR_VERSION}
RUN make -j${BUILD_NCPU} release
RUN strip gffread

# Final exec image
ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}

ARG GFFR_VERSION=0.12.4

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-gffread /build/gffread-${GFFR_VERSION}/gffread /usr/local/bin/gffread
ENTRYPOINT ["/usr/local/bin/gffread"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${GFFR_VERSION}
