FROM alpine AS alpine-build-diamond
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add build-base wget zlib-static zlib-dev cmake

WORKDIR /build

RUN wget https://github.com/bbuchfink/diamond/archive/v0.9.29.tar.gz

RUN tar -xf v0.9.29.tar.gz

WORKDIR /build/diamond-0.9.29/build

# Note: Diamond does not do too well as a static build it seems so I leave it
# dynamic and get the necessary libs
RUN cmake -DCMAKE_BUILD_TYPE=Release ..

RUN make

FROM alpine 
WORKDIR / 
RUN apk update && apk add --no-cache zlib libstdc++ libgcc
COPY --from=alpine-build-diamond /build/diamond-0.9.29/build/diamond /usr/local/bin/diamond
ENTRYPOINT ["/usr/local/bin/diamond"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='0.9.29'