FROM alpine AS alpine-build-minimap2
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG MINIMAP2_VERSION=2.17

RUN apk update && apk add build-base wget zlib-dev zlib-static

WORKDIR /build
RUN wget https://github.com/lh3/minimap2/archive/v${MINIMAP2_VERSION}.tar.gz && \
    tar -xf v${MINIMAP2_VERSION}.tar.gz
WORKDIR /build/minimap2-${MINIMAP2_VERSION}
RUN make CFLAGS='-O2 -Wc++-compat -static' LDFLAGS='-static' \
         CPPFLAGS='-static -DHAVE_KALLOC'

FROM alpine 

ARG MINIMAP2_VERSION=2.17

WORKDIR / 
COPY --from=alpine-build-minimap2 /build/minimap2-${MINIMAP2_VERSION}/minimap2 /usr/local/bin/minimap2
ENTRYPOINT ["/usr/local/bin/minimap2"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${MINIMAP2_VERSION}