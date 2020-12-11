ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-diamond
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG DIAMOND_VERSION=2.0.5
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-static zlib-dev cmake

WORKDIR /build

RUN wget https://github.com/bbuchfink/diamond/archive/v${DIAMOND_VERSION}.tar.gz

RUN tar -xf v${DIAMOND_VERSION}.tar.gz

WORKDIR /build/diamond-${DIAMOND_VERSION}/build

# Note: Diamond does not do too well as a static build it seems so I leave it
# dynamic and get the necessary libs
RUN cmake -DCMAKE_BUILD_TYPE=Release ..

RUN make -j${BUILD_NCPU}
RUN strip diamond

FROM alpine:${ALPINE_VERSION}

ARG DIAMOND_VERSION=2.0.5

RUN apk add --no-cache bash

WORKDIR / 
RUN apk add --no-cache zlib libstdc++ libgcc
COPY --from=alpine-build-diamond /build/diamond-${DIAMOND_VERSION}/build/diamond /usr/local/bin/diamond
ENTRYPOINT ["/usr/local/bin/diamond"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${DIAMOND_VERSION}
