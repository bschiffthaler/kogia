ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-clustalw

ARG ALPINE_VERSION=3.12
ARG CW_VERSION=2.1
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base make
RUN wget http://www.clustal.org/download/current/clustalw-${CW_VERSION}.tar.gz
RUN tar -zxf clustalw-${CW_VERSION}.tar.gz
WORKDIR /build/clustalw-${CW_VERSION}
RUN ./configure && make -j${BUILD_NCPU}
RUN strip src/clustalw2

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG CW_VERSION=2.1

WORKDIR /
RUN apk add --no-cache bash
#RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-clustalw /build/clustalw-${CW_VERSION}/src/clustalw2 /usr/local/bin/clustalw2
ENTRYPOINT ["/usr/local/bin/clustalw2"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${CW_VERSION}
