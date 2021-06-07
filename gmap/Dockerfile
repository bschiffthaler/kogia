ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION} AS alpine-build-gmap

ARG ALPINE_VERSION=3.13
ARG GMAP_VERSION=2021-05-27
ARG BUILD_NCPU=1

RUN apk update && apk add build-base zlib-dev libexecinfo-dev \
    bzip2-dev xz-dev python3 py3-setuptools file perl

WORKDIR /build
RUN wget http://research-pub.gene.com/gmap/src/gmap-gsnap-${GMAP_VERSION}.tar.gz
RUN tar -xf gmap-gsnap-${GMAP_VERSION}.tar.gz
WORKDIR /build/gmap-${GMAP_VERSION}/
RUN ./configure --prefix=/build/dist
RUN make -j${BUILD_NCPU} && make install
WORKDIR /build/dist/bin
RUN for f in *; \
    do \
      x=$(file $f) ;\
      if ! echo "$x" | grep -q "text"; then \
        strip $f ;\
      fi ;\
    done

FROM alpine:${ALPINE_VERSION}

ARG GMAP_VERSION=2021-05-27

RUN apk add --no-cache bash
RUN apk add --no-cache libbz2 perl

WORKDIR / 
COPY --from=alpine-build-gmap /build/dist/bin/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/gmap"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${GMAP_VERSION}
