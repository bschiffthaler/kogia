ARG ALPINE_VERSION=3.11
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-gffcompare

ARG ALPINE_VERSION=3.11

# clone the repo, latest was 0.11.6 - 4 changes more on 28/4/2020
ARG GFFC_VERSION=0.11.6

WORKDIR /build
RUN apk update && apk add build-base git
RUN git clone https://github.com/gpertea/gffcompare.git
WORKDIR /build/gffcompare
RUN make release
RUN strip gffcompare

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG GFFC_VERSION=0.11.6

WORKDIR /
COPY --from=alpine-build-gffcompare /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=alpine-build-gffcompare /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=alpine-build-gffcompare /build/gffcompare/gffcompare /usr/local/bin/gffcompare
ENTRYPOINT ["/usr/local/bin/gffcompare"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${GFFC_VERSION}
