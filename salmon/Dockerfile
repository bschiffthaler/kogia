FROM alpine AS alpine-build-salmon
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG TBB_VERSION=2019_U9
ARG SALMON_VERSION=1.1.0

RUN apk update && apk add build-base wget zlib-static zlib-dev bzip2-static \
    bzip2-dev xz-dev xz boost-static boost-dev curl-dev curl bash automake \
    autoconf linux-headers cmake

WORKDIR /build

# We need to build TBB from source as the apk versions are really old
RUN wget https://github.com/intel/tbb/archive/${TBB_VERSION}.tar.gz && \
    tar -xf ${TBB_VERSION}.tar.gz
WORKDIR /build
RUN cp -r /build/tbb-${TBB_VERSION} /build/tbb-${TBB_VERSION}_new
COPY tbb-${TBB_VERSION}-alpine-3.10.3.patch /build/tbb-${TBB_VERSION}-alpine-3.10.3.patch 
RUN patch -p0 < tbb-${TBB_VERSION}-alpine-3.10.3.patch 

WORKDIR /build/tbb-${TBB_VERSION}_new

RUN make && \
    cp ./build/linux_*_release/lib* \
        /usr/local/lib && \
    mkdir /usr/local/include && \
    cp -r ./include/tbb /usr/local/include/tbb && \
    cp -r ./include/serial /usr/local/include/serial

WORKDIR /build/
RUN wget https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz && \
    tar -xf v${SALMON_VERSION}.tar.gz

WORKDIR /build/salmon-${SALMON_VERSION}/build

RUN CXXFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    CFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    cmake .. && \
    make 

FROM alpine 

ARG TBB_VERSION=2019_U9
ARG SALMON_VERSION=1.1.0

WORKDIR / 
COPY --from=alpine-build-salmon /build/salmon-${SALMON_VERSION}/build/src/salmon /usr/local/bin/salmon
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc.so /usr/local/lib/libtbbmalloc.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc.so.2 /usr/local/lib/libtbbmalloc.so.2 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc_proxy.so /usr/local/lib/libtbbmalloc_proxy.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbbmalloc_proxy.so.2 /usr/local/lib/libtbbmalloc_proxy.so.2 
COPY --from=alpine-build-salmon /usr/local/lib/libtbb.so /usr/local/lib/libtbb.so 
COPY --from=alpine-build-salmon /usr/local/lib/libtbb.so.2 /usr/local/lib/libtbb.so.2
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update && apk add --no-cache libstdc++ libc6-compat
ENTRYPOINT ["/usr/local/bin/salmon"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SALMON_VERSION}

