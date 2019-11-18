# Build image
FROM alpine AS alpine-build-bwa
WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar
RUN wget https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2
RUN tar -xf bwa-0.7.17.tar.bz2
WORKDIR /build/bwa-0.7.17
RUN make CFLAGS="-static -g -Wall -Wno-unused-function -O2"

# Final exec image
FROM alpine 
WORKDIR / 
COPY --from=alpine-build-bwa /build/bwa-0.7.17/bwa /usr/local/bin/bwa
ENTRYPOINT ["/usr/local/bin/bwa"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='0.7.17'