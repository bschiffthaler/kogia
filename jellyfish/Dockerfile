ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-jellyfish

ARG ALPINE_VERSION=3.12
ARG JELLYFISH_VERSION=2.3.0
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar zlib-static
RUN wget https://github.com/gmarcais/Jellyfish/releases/download/v${JELLYFISH_VERSION}/jellyfish-${JELLYFISH_VERSION}.tar.gz
RUN tar -xf jellyfish-${JELLYFISH_VERSION}.tar.gz
WORKDIR /build/jellyfish-${JELLYFISH_VERSION}
RUN ./configure --prefix=/build/jellyfish-${JELLYFISH_VERSION}/prefix && \
    make -j${BUILD_NCPU} && \
    make install
RUN strip /build/jellyfish-${JELLYFISH_VERSION}/prefix/bin/jellyfish

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG JELLYFISH_VERSION=2.3.0

RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++
WORKDIR / 
COPY --from=alpine-build-jellyfish /build/jellyfish-${JELLYFISH_VERSION}/prefix/bin/jellyfish /usr/local/bin/jellyfish
COPY --from=alpine-build-jellyfish /build/jellyfish-${JELLYFISH_VERSION}/prefix/lib/libjellyfish-2.0.so.2 /usr/local/lib/
ENTRYPOINT ["/usr/local/bin/jellyfish"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${JELLYFISH_VERSION}
