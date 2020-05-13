ARG ALPINE_VERSION=3.11
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-trmap

ARG ALPINE_VERSION=3.11

# clone the repo, latest was 0.11.6 - 4 changes more on 28/4/2020
ARG GFFC_VERSION=0.11.6

WORKDIR /build
RUN apk update && apk add build-base git
RUN git clone https://github.com/gpertea/gffcompare.git
WORKDIR /build/gffcompare
RUN make release
RUN strip trmap

# Final exec image
ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION}

ARG TRMAP_VERSION=0.11.6

RUN apk update && apk add --no-cache libstdc++ libgcc

WORKDIR / 
COPY --from=alpine-build-trmap /build/gffcompare/trmap /usr/local/bin/trmap
ENTRYPOINT ["/usr/local/bin/trmap"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${TRMAP_VERSION}
