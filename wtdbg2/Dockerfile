FROM alpine AS alpine-build-wtdbg2
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG WTDBG2_VERSION=2.5
ARG SAMTOOLS_VERSION=1.9
ARG MINIMAP2_VERSION=2.17

RUN apk update && apk add build-base zlib-dev libexecinfo-dev \
    bzip2-dev xz-dev curl-dev ncurses-dev

# WTDBG2
WORKDIR /build
RUN wget https://github.com/ruanjue/wtdbg2/archive/v${WTDBG2_VERSION}.tar.gz
RUN tar -xf v${WTDBG2_VERSION}.tar.gz
RUN cp -r wtdbg2-${WTDBG2_VERSION} wtdbg2-${WTDBG2_VERSION}_new
COPY wtdbg2-${WTDBG2_VERSION}-alpine-3.10.3.patch wtdbg2-${WTDBG2_VERSION}-alpine-3.10.3.patch
RUN patch -p0 < wtdbg2-${WTDBG2_VERSION}-alpine-3.10.3.patch
WORKDIR /build/wtdbg2-${WTDBG2_VERSION}_new
RUN make GLIBS='-lm -lrt -lpthread -lz -lexecinfo'

# Samtools
WORKDIR /build
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN tar -xf samtools-${SAMTOOLS_VERSION}.tar.bz2
WORKDIR /build/samtools-${SAMTOOLS_VERSION}
RUN ./configure && \
    make

# Minimap2
WORKDIR /build
RUN wget https://github.com/lh3/minimap2/archive/v${MINIMAP2_VERSION}.tar.gz
RUN tar -xf v${MINIMAP2_VERSION}.tar.gz
WORKDIR /build/minimap2-${MINIMAP2_VERSION}
RUN make 

FROM alpine

ARG WTDBG2_VERSION=2.5
ARG SAMTOOLS_VERSION=1.9
ARG MINIMAP2_VERSION=2.17
ARG WITH_PERL

RUN apk add --no-cache ncurses-libs xz-libs libbz2 libexecinfo libcurl perl

WORKDIR / 
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/kbm2 /usr/local/bin/
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/pgzf /usr/local/bin/
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/wtdbg-cns /usr/local/bin/
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/wtpoa-cns /usr/local/bin/
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/wtdbg2 /usr/local/bin/
COPY --from=alpine-build-wtdbg2 /build/wtdbg2-${WTDBG2_VERSION}_new/wtdbg2.pl /usr/local/bin/

COPY --from=alpine-build-wtdbg2 /build/samtools-${SAMTOOLS_VERSION}/samtools /usr/local/bin/samtools

COPY --from=alpine-build-wtdbg2 /build/minimap2-${MINIMAP2_VERSION}/minimap2 /usr/local/bin/minimap2

ENTRYPOINT ["/usr/local/bin/wtdbg2.pl"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${WTDBG2_VERSION}