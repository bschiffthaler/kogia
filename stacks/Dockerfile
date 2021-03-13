ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION} AS alpine-build-stacks

ARG ALPINE_VERSION=3.12
ARG STACKS_VERSION=2.55
ARG BUILD_NCPU=1

RUN apk update && apk add build-base zlib-dev zlib-static make sed

# Stacks
WORKDIR /build
RUN wget http://catchenlab.life.illinois.edu/stacks/source/stacks-${STACKS_VERSION}.tar.gz
RUN tar -xf stacks-${STACKS_VERSION}.tar.gz
WORKDIR /build/stacks-${STACKS_VERSION}
RUN echo '#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO)' > inc.h
ENV CFLAGS='-include inc.h'
ENV CXXFLAGS='-include inc.h'
RUN ./configure MKDIR_P="mkdir -p" && make -j${BUILD_NCPU}
RUN make install 
RUN strip /usr/local/bin/*stacks /usr/local/bin/populations \
  /usr/local/bin/process_shortreads /usr/local/bin/process_radtags \
  /usr/local/bin/tsv2bam
FROM alpine:${ALPINE_VERSION}

ARG STACKS_VERSION=2.55

RUN apk add --no-cache perl python3 libgomp libstdc++

WORKDIR / 
RUN apk add --no-cache bash
COPY --from=alpine-build-stacks /usr/local/bin/cstacks /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/gstacks /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/ustacks /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/sstacks /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/phasedstacks /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/populations /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/process_shortreads /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/process_radtags /usr/local/bin/
COPY --from=alpine-build-stacks /usr/local/bin/tsv2bam /usr/local/bin/

COPY --from=alpine-build-stacks /usr/local/bin/* /usr/local/bin/

RUN chmod a+x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/denovo_map.pl"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${STACKS_VERSION}
