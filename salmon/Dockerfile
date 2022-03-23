ARG ALPINE_VERSION=3.14

FROM alpine:${ALPINE_VERSION} AS alpine-build-salmon

ARG ALPINE_VERSION=3.14
ARG SALMON_VERSION=1.8.0
ARG BUILD_NCPU=1

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add build-base wget zlib-static zlib-dev bzip2-static \
    bzip2-dev xz-dev xz boost-static boost-dev curl-dev curl bash automake \
    autoconf linux-headers cmake musl-utils libexecinfo-dev libtbb-dev

WORKDIR /build/
RUN wget https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz && \
    tar -xf v${SALMON_VERSION}.tar.gz
WORKDIR /build/salmon-${SALMON_VERSION}/build

RUN CXXFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    CFLAGS='-fpermissive -D"u_int64_t=uint64_t" -D"ACCESSPERMS=(S_IRWXU|S_IRWXG|S_IRWXO)"' \
    LDFLAGS='-lexecinfo' \
    cmake -DNO_IPO=ON -DCURL_LIBRARY=/usr/lib/libcurl.so -DIconv_IS_BUILT_IN=TRUE .. && \
    make -j${BUILD_NCPU}
RUN strip src/salmon

FROM alpine:${ALPINE_VERSION}

ARG SALMON_VERSION=1.8.0

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libexecinfo
COPY --from=alpine-build-salmon /build/salmon-${SALMON_VERSION}/build/src/salmon /usr/local/bin/salmon
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk add --no-cache libstdc++ libc6-compat libtbb
ENTRYPOINT ["/usr/local/bin/salmon"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SALMON_VERSION}
