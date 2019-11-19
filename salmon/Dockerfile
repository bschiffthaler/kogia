FROM alpine AS alpine-build-salmon
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add build-base wget zlib-static zlib-dev bzip2-static \
    bzip2-dev xz-dev xz boost-static boost-dev curl-dev curl bash automake \
    autoconf linux-headers cmake

WORKDIR /build

# We need to build TBB from source as the apk versions are really old
RUN wget https://github.com/intel/tbb/archive/2019_U9.tar.gz && \
    tar -xf 2019_U9.tar.gz

WORKDIR /build/tbb-2019_U9

# Need patched files to build against musl
COPY proxy.cpp /build/tbb-2019_U9/src/tbbmalloc/proxy.cpp
COPY proxy.h /build/tbb-2019_U9/src/tbbmalloc/proxy.h

RUN make && \
    cp ./build/linux_*_release/lib* \
        /usr/local/lib && \
    mkdir /usr/local/include && \
    cp -r ./include/tbb /usr/local/include/tbb && \
    cp -r ./include/serial /usr/local/include/serial

WORKDIR /build/
RUN wget https://github.com/COMBINE-lab/salmon/archive/v1.0.0.tar.gz && \
    tar -xf v1.0.0.tar.gz

WORKDIR /build/salmon-1.0.0/build

RUN CXXFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    CFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    cmake .. && \
    make 

FROM alpine 
WORKDIR / 
COPY --from=alpine-build-salmon /build/salmon-1.0.0/build/src/salmon /usr/local/bin/salmon
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
LABEL software.version='1.0.0'

