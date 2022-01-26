ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-transrate

ARG ALPINE_VERSION=3.12
ARG BUILD_NCPU=1

RUN apk update &&\
    apk add git ruby-dev gcc make zlib-static zlib-dev bash curl boost-dev \
    bzip2-dev bzip2-static xz-dev autoconf automake boost-static patch cmake \
    g++ build-base

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update &&\
    apk add libtbb-dev

WORKDIR /build

RUN  git clone --recursive https://github.com/blahah/transrate-tools.git
COPY bamtools-alpine-${ALPINE_VERSION}.patch ./
RUN  patch transrate-tools/bamtools/src/toolkit/bamtools_resolve.cpp bamtools-alpine-${ALPINE_VERSION}.patch
RUN cd transrate-tools/bamtools &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j${BUILD_NCPU} &&\
    cd ../../ &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j${BUILD_NCPU}

WORKDIR /build
RUN wget https://github.com/amplab/snap/archive/v1.0.0.tar.gz &&\
    tar -xvf v1.0.0.tar.gz &&\
    cd snap-1.0.0 &&\
    make -j${BUILD_NCPU}

WORKDIR /build
RUN wget https://github.com/COMBINE-lab/salmon/archive/v0.13.1.tar.gz
RUN tar -xf v0.13.1.tar.gz

COPY bamutils-alpine-${ALPINE_VERSION}.patch ./
COPY int128-alpine-${ALPINE_VERSION}.patch ./

RUN patch salmon-0.13.1/include/jellyfish/int128.hpp int128-alpine-${ALPINE_VERSION}.patch &&\
    patch salmon-0.13.1/include/BAMUtils.hpp bamutils-alpine-${ALPINE_VERSION}.patch

RUN cd salmon-0.13.1 &&\
    mkdir build && cd build &&\
    CXXFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' cmake .. &&\
    make -j${BUILD_NCPU}

RUN gem install specific_install &&\
    gem install io-console &&\
    gem git_install https://github.com/bschiffthaler/transrate

ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ruby libc6-compat libexecinfo libgcc libstdc++
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk add --no-cache libtbb libgomp

COPY --from=alpine-build-transrate /build/salmon-0.13.1/build/src/salmon /usr/local/bin/salmon
COPY --from=alpine-build-transrate /build/snap-1.0.0/snap-aligner /usr/local/bin/snap-aligner
COPY --from=alpine-build-transrate /build/transrate-tools/build/src/bam-read /usr/local/bin/bam-read
COPY --from=alpine-build-transrate /usr/lib/ruby /usr/lib/ruby
COPY --from=bschiffthaler/ncbi-blast /usr/local/bin/* /usr/local/bin/
COPY --from=bschiffthaler/ncbi-blast /usr/local/lib/* /usr/local/lib/

ENV PATH=/usr/lib/ruby/gems/2.7.0/gems/transrate-1.0.3/bin:$PATH

ENTRYPOINT ["/usr/lib/ruby/gems/2.7.0/gems/transrate-1.0.3/bin/transrate"]
