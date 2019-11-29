FROM alpine AS alpine-build-diamond
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG DIAMOND_VERSION=0.9.29

RUN apk update && apk add build-base wget zlib-static zlib-dev cmake

WORKDIR /build

RUN wget https://github.com/bbuchfink/diamond/archive/v${DIAMOND_VERSION}.tar.gz

RUN tar -xf v${DIAMOND_VERSION}.tar.gz

WORKDIR /build/diamond-${DIAMOND_VERSION}/build

# Note: Diamond does not do too well as a static build it seems so I leave it
# dynamic and get the necessary libs
RUN cmake -DCMAKE_BUILD_TYPE=Release ..

RUN make

FROM alpine 

ARG DIAMOND_VERSION=0.9.29

WORKDIR / 
RUN apk update && apk add --no-cache zlib libstdc++ libgcc
COPY --from=alpine-build-diamond /build/diamond-${DIAMOND_VERSION}/build/diamond /usr/local/bin/diamond
ENTRYPOINT ["/usr/local/bin/diamond"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${DIAMOND_VERSION}