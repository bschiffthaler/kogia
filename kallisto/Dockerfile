FROM alpine AS alpine-build-kallisto
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

RUN apk update && apk add build-base wget hdf5-dev hdf5-static curl-dev \
    curl-static zlib-dev zlib-static cmake autoconf libcurl

WORKDIR /build

RUN wget https://github.com/pachterlab/kallisto/archive/v0.46.1.tar.gz && \
    tar -xf v0.46.1.tar.gz

WORKDIR /build/kallisto-0.46.1/build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DLINK=static .. && make

FROM alpine 
WORKDIR / 
COPY --from=alpine-build-kallisto /build/kallisto-0.46.1/build/src/kallisto /usr/local/bin/kallisto
ENTRYPOINT ["/usr/local/bin/kallisto"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='0.46.1'