ARG ALPINE_VERSION=3.13
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-caviar

ARG ALPINE_VERSION=3.13
ARG CV_VERSION=19.04.19
ARG BUILD_NCPU=4

WORKDIR /build
RUN apk update && apk add build-base blas-dev git gsl-dev lapack-dev make
RUN git clone https://github.com/fhormoz/caviar.git
WORKDIR /build/caviar/CAVIAR-C++
COPY caviar-19.04.14-alpine-3.13.patch /build/caviar/CAVIAR-C++
RUN patch -p0 --ignore-whitespace < caviar-19.04.14-alpine-3.13.patch
RUN make -j${BUILD_NCPU}
RUN strip CAVIAR && strip eCAVIAR

# Final exec image
FROM alpine:${ALPINE_VERSION}

ARG GT_VERSION=19.04.19

WORKDIR /
RUN apk add --no-cache bash
#RUN apk add --no-cache libstdc++ libgcc
COPY --from=alpine-build-caviar /usr/lib/libgsl.so.25 /usr/lib/libgsl.so.25
COPY --from=alpine-build-caviar /usr/lib/libgfortran.so.5 /usr/lib/libgfortran.so.5
COPY --from=alpine-build-caviar /usr/lib/libquadmath.so.0 /usr/lib/libquadmath.so.0
COPY --from=alpine-build-caviar /usr/lib/liblapack.so.3 /usr/lib/liblapack.so.3
COPY --from=alpine-build-caviar /usr/lib/libblas.so.3 /usr/lib/libblas.so.3
COPY --from=alpine-build-caviar /usr/lib/libgslcblas.so.0 /usr/lib/libgslcblas.so.0
COPY --from=alpine-build-caviar /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=alpine-build-caviar /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=alpine-build-caviar /build/caviar/CAVIAR-C++/CAVIAR /usr/local/bin/CAVIAR
COPY --from=alpine-build-caviar /build/caviar/CAVIAR-C++/eCAVIAR /usr/local/bin/eCAVIAR
ENTRYPOINT ["/usr/local/bin/CAVIAR"]

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${CV_VERSION}
