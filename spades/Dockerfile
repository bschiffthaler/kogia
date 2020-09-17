ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-spades
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.12
ARG SPADES_VERSION=3.14.1

RUN apk update && apk add wget

RUN mkdir /build
WORKDIR /build

RUN wget http://cab.spbu.ru/files/release${SPADES_VERSION}/SPAdes-${SPADES_VERSION}-Linux.tar.gz

RUN tar -xf SPAdes-${SPADES_VERSION}-Linux.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG SPADES_VERSION=3.14.1

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache python3 libc6-compat && \
    ln -s $(which python3) /usr/local/bin/python && \
    mkdir /usr/local/share/spades
COPY --from=alpine-build-spades /build/SPAdes-${SPADES_VERSION}-Linux/bin/* /usr/local/bin/
COPY --from=alpine-build-spades /build/SPAdes-${SPADES_VERSION}-Linux/share/* /usr/local/share/spades/

ENTRYPOINT ["/usr/local/bin/spades.py"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SPADES_VERSION}
