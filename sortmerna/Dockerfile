ARG ALPINE_VERSION=3.23

FROM alpine:${ALPINE_VERSION} AS alpine-build-sortmerna
ARG SORTMERNA_VERSION=5.0.0
WORKDIR /build
RUN apk update && apk add curl bash build-base
RUN curl -O -L https://github.com/biocore/sortmerna/releases/download/v${SORTMERNA_VERSION}/sortmerna-${SORTMERNA_VERSION}-Linux.sh
RUN bash sortmerna-${SORTMERNA_VERSION}-Linux.sh --skip-license
RUN strip /build/bin/sortmerna

# Use a glibc-based image to collect the correct libraries via ldd
FROM ubuntu:24.04 AS glibc-libs
COPY --from=alpine-build-sortmerna /build/bin/sortmerna /tmp/sortmerna
RUN mkdir -p /glibc-libs && \
    ldd /tmp/sortmerna | grep "=> /" | awk '{print $3}' | xargs -I{} cp -L {} /glibc-libs/ && \
    cp -L /lib64/ld-linux-x86-64.so.2 /glibc-libs/

# Final Alpine image with bundled glibc libs
FROM alpine:${ALPINE_VERSION}
ARG SORTMERNA_VERSION=5.0.0
WORKDIR /
RUN apk add --no-cache bash
RUN mkdir -p /lib/glibc-compat /lib64
COPY --from=glibc-libs /glibc-libs/ /lib/glibc-compat/
RUN ln -sf /lib/glibc-compat/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=alpine-build-sortmerna /build/bin/sortmerna /usr/local/bin/sortmerna
ENV LD_LIBRARY_PATH=/lib/glibc-compat
ENTRYPOINT ["/usr/local/bin/sortmerna"]
LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SORTMERNA_VERSION}