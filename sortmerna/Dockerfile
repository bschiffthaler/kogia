ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-sortmerna

ARG ALPINE_VERSION=3.12
ARG SORTMERNA_VERSION=4.2.0

WORKDIR /build
RUN apk update && apk add curl bash build-base

WORKDIR /build
RUN curl -O -L https://github.com/biocore/sortmerna/releases/download/v${SORTMERNA_VERSION}/sortmerna-${SORTMERNA_VERSION}-Linux.sh
RUN bash sortmerna-${SORTMERNA_VERSION}-Linux.sh --skip-license
RUN strip /build/bin/sortmerna

FROM alpine:${ALPINE_VERSION}

ARG SORTMERNA_VERSION=4.2.0

WORKDIR / 
RUN apk add --no-cache bash
COPY --from=alpine-build-sortmerna /build/bin/sortmerna /usr/local/bin/sortmerna
ENTRYPOINT ["/usr/local/bin/sortmerna"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SORTMERNA_VERSION}
