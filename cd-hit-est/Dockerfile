ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-cd-hit

ARG ALPINE_VERSION=3.12
ARG CDHIT_VERSION=4.8.1
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base make zlib-dev
RUN wget https://github.com/weizhongli/cdhit/archive/V${CDHIT_VERSION}.tar.gz
RUN tar -xf V${CDHIT_VERSION}.tar.gz
WORKDIR /build/cdhit-${CDHIT_VERSION}
RUN make -j${BUILD_NCPU}
RUN strip cd-hit-est

# Final exec image - cd-hit-est
FROM alpine:${ALPINE_VERSION}

ARG CDHIT_VERSION=4.8.1

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc libgomp zlib
COPY --from=alpine-build-cd-hit /build/cdhit-${CDHIT_VERSION}/cd-hit-est /usr/local/bin/cd-hit-est
ENTRYPOINT ["/usr/local/bin/cd-hit-est"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${CDHIT_VERSION}
