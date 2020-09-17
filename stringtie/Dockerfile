ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-stringtie

ARG ALPINE_VERSION=3.12
ARG ST_VERSION=2.1.4
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base git zlib-dev wget
RUN wget https://github.com/gpertea/stringtie/releases/download/v${ST_VERSION}/stringtie-${ST_VERSION}.tar.gz
RUN tar -xf stringtie-${ST_VERSION}.tar.gz
WORKDIR /build/stringtie-${ST_VERSION}
RUN CXXFLAGS='-include /usr/include/c++/**/cstdint' make -j${BUILD_NCPU} clean release
RUN strip stringtie

# Final exec image
ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}
ARG ST_VERSION=2.1.4

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-stringtie /build/stringtie-${ST_VERSION}/stringtie /usr/local/bin/stringtie
ENTRYPOINT ["/usr/local/bin/stringtie"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${ST_VERSION}
