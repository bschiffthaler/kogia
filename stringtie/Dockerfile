ARG ALPINE_VERSION=3.11
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-stringtie

ARG ALPINE_VERSION=3.11
ARG ST_VERSION=2.1.3

WORKDIR /build
RUN apk update && apk add build-base git zlib-dev wget
RUN wget https://github.com/gpertea/stringtie/releases/download/v${ST_VERSION}/stringtie-${ST_VERSION}.tar.gz
RUN tar -xf stringtie-${ST_VERSION}.tar.gz
WORKDIR /build/stringtie-${ST_VERSION}
RUN CXXFLAGS='-include /usr/include/c++/**/cstdint' make clean release
RUN strip stringtie

# Final exec image
ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION}
ARG ST_VERSION=2.1.3

WORKDIR /
COPY --from=alpine-build-stringtie /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=alpine-build-stringtie /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=alpine-build-stringtie /build/stringtie-${ST_VERSION}/stringtie /usr/local/bin/stringtie
ENTRYPOINT ["/usr/local/bin/stringtie"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${ST_VERSION}
