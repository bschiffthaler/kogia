ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-salmon
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG TBB_VERSION=2020.2
ARG SALMON_VERSION=1.4.0
ARG BUILD_NCPU=1

RUN apk update && apk add build-base wget zlib-static zlib-dev bzip2-static \
    bzip2-dev xz-dev xz boost-static boost-dev curl-dev curl bash automake \
    autoconf linux-headers cmake musl-utils

WORKDIR /build

# We need to build TBB from source as the apk versions are really old
RUN wget https://github.com/oneapi-src/oneTBB/archive/v${TBB_VERSION}.tar.gz && \
    tar -xf v${TBB_VERSION}.tar.gz
RUN cp -r /build/oneTBB-${TBB_VERSION} /build/oneTBB-${TBB_VERSION}_new
COPY oneTBB-${TBB_VERSION}-alpine-${ALPINE_VERSION}.patch /build/oneTBB-${TBB_VERSION}-alpine-${ALPINE_VERSION}.patch 
RUN patch -p0 < oneTBB-${TBB_VERSION}-alpine-${ALPINE_VERSION}.patch 

WORKDIR /build/oneTBB-${TBB_VERSION}

RUN make -j${BUILD_NCPU} && \
    cp ./build/linux_*_release/lib* \
        /usr/local/lib && \
    mkdir /usr/local/include && \
    cp -r ./include/tbb /usr/local/include/tbb && \
    cp -r ./include/serial /usr/local/include/serial

WORKDIR /build/
RUN wget https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz && \
    tar -xf v${SALMON_VERSION}.tar.gz
RUN cp -r salmon-${SALMON_VERSION} salmon-${SALMON_VERSION}_new
COPY salmon-${SALMON_VERSION}-alpine-${ALPINE_VERSION}.patch /build/salmon-${SALMON_VERSION}-alpine-${ALPINE_VERSION}.patch
RUN patch -p0 < salmon-${SALMON_VERSION}-alpine-${ALPINE_VERSION}.patch
WORKDIR /build/salmon-${SALMON_VERSION}/build

RUN CXXFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    CFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    cmake -DNO_IPO=ON -DCURL_LIBRARY=/usr/lib/libcurl.so -DIconv_IS_BUILT_IN=TRUE .. && \
    make -j${BUILD_NCPU}
RUN strip /usr/local/lib/libtbb*.so.* src/salmon

FROM alpine:${ALPINE_VERSION}

ARG TBB_VERSION=2020.2
ARG SALMON_VERSION=1.4.0

WORKDIR / 
RUN apk add --no-cache bash
COPY --from=alpine-build-salmon /build/salmon-${SALMON_VERSION}/build/src/salmon /usr/local/bin/salmon
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc.so /usr/local/lib/libtbbmalloc.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc.so.2 /usr/local/lib/libtbbmalloc.so.2 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc_proxy.so /usr/local/lib/libtbbmalloc_proxy.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc_proxy.so.2 /usr/local/lib/libtbbmalloc_proxy.so.2 
COPY --from=alpine-build-salmon /usr/local/lib/libtbb.so /usr/local/lib/libtbb.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbb.so.2 /usr/local/lib/libtbb.so.2
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk add --no-cache libstdc++ libc6-compat
ENTRYPOINT ["/usr/local/bin/salmon"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SALMON_VERSION}

