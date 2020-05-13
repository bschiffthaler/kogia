ARG ALPINE_VERSION=3.11
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-gffread

ARG ALPINE_VERSION=3.11

# clone the repo, latest was 0.11.8 - 3 changes more on 28/4/2020
ARG GFFR_VERSION=0.11.8

WORKDIR /build
RUN apk update && apk add build-base git
RUN git clone https://github.com/gpertea/gffread.git
WORKDIR /build/gffread
RUN make release
RUN strip gffread

# Final exec image
ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION}

ARG GFFR_VERSION=0.11.8

WORKDIR /
RUN apk update && apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-gffread /build/gffread/gffread /usr/local/bin/gffread
ENTRYPOINT ["/usr/local/bin/gffread"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${GFFR_VERSION}
