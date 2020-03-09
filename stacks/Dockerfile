ARG ALPINE_VERSION=3.11
FROM alpine:${ALPINE_VERSION} AS alpine-build-stacks
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG ALPINE_VERSION=3.11
ARG STACKS_VERSION=2.52

RUN apk update && apk add build-base zlib-dev zlib-static autoconf automake \
    make

# WTDBG2
WORKDIR /build
RUN wget http://catchenlab.life.illinois.edu/stacks/source/stacks-${STACKS_VERSION}.tar.gz
RUN tar -xf stacks-${STACKS_VERSION}.tar.gz
WORKDIR /build/stacks-${STACKS_VERSION}
RUN autoreconf && autoconf
RUN echo '#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO)' > inc.h
RUN CFLAGS='-include inc.h' CXXFLAGS='-include inc.h' \
    ./configure && make

FROM alpine:${ALPINE_VERSION}

ARG STACKS_VERSION=2.52

RUN apk add --no-cache perl python libgomp libstdc++

WORKDIR / 

COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/cstacks /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/gstacks /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/ustacks /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/sstacks /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/phasedstacks /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/populations /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/process_shortreads /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/process_radtags /usr/local/bin/
COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/tsv2bam /usr/local/bin/

COPY --from=alpine-build-stacks /build/stacks-${STACKS_VERSION}/scripts/* /usr/local/bin/

RUN chmod a+x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/denovo_map.pl"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${STACKS_VERSION}