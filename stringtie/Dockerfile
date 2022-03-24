ARG ALPINE_VERSION=3.14
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-stringtie

ARG ALPINE_VERSION=3.14
ARG ST_VERSION=2.2.1
ARG BUILD_NCPU=1

RUN apk update && apk add build-base git zlib-dev wget python3-dev py3-pip py3-wheel \
    cython bash curl

WORKDIR /build
RUN git clone https://github.com/pyinstaller/pyinstaller
WORKDIR /build/pyinstaller/bootloader
RUN CFLAGS="-Wno-stringop-overflow" python3 ./waf configure --no-lsb all && \
    pip3 install ..

WORKDIR /build
RUN wget https://github.com/gpertea/stringtie/releases/download/v${ST_VERSION}/stringtie-${ST_VERSION}.tar.gz
RUN tar -xf stringtie-${ST_VERSION}.tar.gz
WORKDIR /build/stringtie-${ST_VERSION}
RUN CXXFLAGS='-include /usr/include/c++/**/cstdint' make -j${BUILD_NCPU} clean release
RUN rm prepDE.py && pyinstaller --onefile -s prepDE.py3
RUN strip stringtie



# Final exec image
ARG ALPINE_VERSION=3.14
FROM alpine:${ALPINE_VERSION}
ARG ST_VERSION=2.2.1

WORKDIR /
RUN apk add --no-cache bash
RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-stringtie /build/stringtie-${ST_VERSION}/stringtie /usr/local/bin/stringtie
COPY --from=alpine-build-stringtie /build/stringtie-${ST_VERSION}/dist/prepDE /usr/local/bin/prepDE
ENTRYPOINT ["/usr/local/bin/stringtie"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${ST_VERSION}
