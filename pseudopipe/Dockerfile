ARG ALPINE_VERSION=3.13
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-ppipe

ARG ALPINE_VERSION=3.13
ARG BUILD_NCPU=1

WORKDIR /build
RUN apk update && apk add build-base wget
RUN wget http://pseudogene.org/DOWNLOADS/pipeline_codes/dependencies.zip
RUN unzip dependencies.zip && tar -xvf dependencies/fasta-35.1.5.tar.gz
WORKDIR /build/fasta-35.1.5
RUN make -f Makefile.linux && \
    mkdir -p dist/bin && \
    make -f Makefile.linux XDIR=/build/fasta-35.1.5/dist/bin install
WORKDIR /build
RUN wget http://pseudogene.org/DOWNLOADS/pipeline_codes/ppipe.tar.gz && \
    tar -xvf ppipe.tar.gz
COPY env.sh /build/pgenes/pseudopipe/bin/env.sh

# Final exec image
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache bash
RUN apk add --no-cache python2

WORKDIR / 
COPY --from=bschiffthaler/ncbi-blast:2.2.13 /usr/local/bin/formatdb /usr/local/bin/
COPY --from=bschiffthaler/ncbi-blast:2.2.13 /usr/local/bin/blastall /usr/local/bin/
COPY --from=bschiffthaler/ncbi-blast:2.2.13 /var/share/ncbi/data /var/share/ncbi/data
COPY --from=alpine-build-ppipe /build/fasta-35.1.5/dist/bin/tfasty35 /usr/local/bin/
COPY --from=alpine-build-ppipe /build/pgenes/pseudopipe /usr/local/bin/pseudopipe
COPY --from=alpine-build-ppipe /build/pgenes/ppipe_input /var/share/ppipe_input
COPY --from=alpine-build-ppipe /build/pgenes/ppipe_output /var/share/ppipe_output

ENV BLASTMAT=/var/share/ncbi/data

ENTRYPOINT ["/usr/local/bin/pseudopipe/bin/pseudopipe.sh"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BWA_VERSION}
