FROM alpine AS alpine-build-sortmerna
WORKDIR /build
RUN apk update && apk add curl bash

WORKDIR /build
RUN curl -O -L https://github.com/biocore/sortmerna/releases/download/v3.0.4/sortmerna-3.0.4-Linux.sh
RUN bash sortmerna-3.0.4-Linux.sh --skip-license


FROM alpine 
WORKDIR / 
COPY --from=alpine-build-sortmerna /build/bin/sortmerna /usr/local/bin/sortmerna
COPY --from=alpine-build-sortmerna /build/bin/indexdb /usr/local/bin/indexdb
ENTRYPOINT ["/usr/local/bin/sortmerna"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='3.0.4'