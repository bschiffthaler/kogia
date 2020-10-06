ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-genometools

ARG ALPINE_VERSION=3.12
ARG GT_VERSION=1.6.1
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base make
RUN wget http://genometools.org/pub/genometools-${GT_VERSION}.tar.gz
RUN tar -zxf genometools-${GT_VERSION}.tar.gz
WORKDIR /build/genometools-${GT_VERSION}
RUN make cairo=no -j${BUILD_NCPU}
RUN strip bin/gt

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG GT_VERSION=1.6.1

WORKDIR /
RUN apk add --no-cache bash
#RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-genometools /build/genometools-${GT_VERSION}/bin/gt /usr/local/bin/gt
COPY --from=alpine-build-genometools /build/genometools-${GT_VERSION}/gtdata /usr/local/bin/gtdata
ENTRYPOINT ["/usr/local/bin/gt"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${GT_VERSION}
