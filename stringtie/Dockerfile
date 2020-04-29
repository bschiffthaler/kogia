ARG ALPINE_VERSION=3.11
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-stringtie

ARG ALPINE_VERSION=3.11

# clone the repo, latest was 2.1.2 - 2 changes more on 28/4/2020
ARG ST_VERSION=2.1.2

WORKDIR /build
RUN apk update && apk add build-base git zlib-dev
RUN git clone https://github.com/gpertea/stringtie.git
WORKDIR /build/stringtie
RUN CXXFLAGS='-include /usr/include/c++/**/cstdint' make clean release
RUN strip stringtie

# Final exec image
ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION}

ARG ST_VERSION=2.1.2

WORKDIR /
COPY --from=alpine-build-stringtie /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=alpine-build-stringtie /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=alpine-build-stringtie /build/stringtie/stringtie /usr/local/bin/stringtie
ENTRYPOINT ["/usr/local/bin/stringtie"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${ST_VERSION}
