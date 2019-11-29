FROM alpine AS alpine-build-kallisto
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

ARG KALLISTO_VERSION=0.46.1

RUN apk update && apk add build-base wget hdf5-dev hdf5-static curl-dev \
    curl-static zlib-dev zlib-static cmake autoconf libcurl

WORKDIR /build

RUN wget https://github.com/pachterlab/kallisto/archive/v${KALLISTO_VERSION}.tar.gz && \
    tar -xf v${KALLISTO_VERSION}.tar.gz

WORKDIR /build/kallisto-${KALLISTO_VERSION}/build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DLINK=static .. && make

FROM alpine 

ARG KALLISTO_VERSION=0.46.1

WORKDIR / 
COPY --from=alpine-build-kallisto /build/kallisto-${KALLISTO_VERSION}/build/src/kallisto /usr/local/bin/kallisto
ENTRYPOINT ["/usr/local/bin/kallisto"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${KALLISTO_VERSION}