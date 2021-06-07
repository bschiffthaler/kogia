ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION} AS alpine-build-flye

ARG ALPINE_VERSION=3.13
ARG FLYE_VERSION=2.8.3

RUN apk update && apk add build-base zlib-dev libexecinfo-dev \
    bzip2-dev xz-dev python3 py3-setuptools

# WTDBG2
WORKDIR /build
RUN wget https://github.com/fenderglass/Flye/archive/${FLYE_VERSION}.tar.gz
RUN tar -xf ${FLYE_VERSION}.tar.gz
WORKDIR /build/Flye-${FLYE_VERSION}
RUN LDFLAGS='-lexecinfo' python3 setup.py build
RUN strip bin/flye-*

FROM alpine:${ALPINE_VERSION}

ARG FLYE_VERSION=2.8.3

RUN apk add --no-cache bash
RUN apk add --no-cache python3 libgcc libstdc++ libexecinfo

WORKDIR / 
COPY --from=alpine-build-flye /build/Flye-${FLYE_VERSION}/build/lib/flye /tmp/flye
COPY --from=alpine-build-flye /build/Flye-${FLYE_VERSION}/bin/* /usr/local/bin/
RUN mv /tmp/flye $(python3 -c "import site; print(site.getsitepackages()[0])")/.

ENTRYPOINT ["/usr/local/bin/flye"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${FLYE_VERSION}
