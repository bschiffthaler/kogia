FROM alpine AS alpine-build-minimap2
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add build-base wget zlib-dev zlib-static

WORKDIR /build
RUN wget https://github.com/lh3/minimap2/archive/v2.17.tar.gz && \
    tar -xf v2.17.tar.gz
WORKDIR /build/minimap2-2.17
RUN make CFLAGS='-O2 -Wc++-compat -static' LDFLAGS='-static' \
         CPPFLAGS='-static -DHAVE_KALLOC'

FROM alpine 
WORKDIR / 
COPY --from=alpine-build-minimap2 /build/minimap2-2.17/minimap2 /usr/local/bin/minimap2
ENTRYPOINT ["/usr/local/bin/minimap2"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='2.17'