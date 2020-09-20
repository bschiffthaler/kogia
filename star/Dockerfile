ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-bwa

ARG ALPINE_VERSION=3.12
ARG STAR_VERSION=2.7.6a

WORKDIR /build
RUN apk update && apk add build-base wget zlib-dev tar zlib-static
RUN wget https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz
RUN tar -xf ${STAR_VERSION}.tar.gz
RUN strip /build/STAR-${STAR_VERSION}/bin/Linux_x86_64_static/STAR
RUN strip /build/STAR-${STAR_VERSION}/bin/Linux_x86_64_static/STARlong

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG STAR_VERSION=2.7.6a

WORKDIR / 
RUN apk add --no-cache bash
COPY --from=alpine-build-bwa /build/STAR-${STAR_VERSION}/bin/Linux_x86_64_static/STAR /usr/local/bin/STAR
COPY --from=alpine-build-bwa /build/STAR-${STAR_VERSION}/bin/Linux_x86_64_static/STARlong /usr/local/bin/STARlong

ENTRYPOINT ["/usr/local/bin/STAR"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${STAR_VERSION}
