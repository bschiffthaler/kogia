ARG ALPINE_VERSION=3.12
# Final exec image
FROM alpine:${ALPINE_VERSION}
ARG SED_VERSION=4.8-r0

WORKDIR / 

RUN apk add --no-cache bash
RUN apk add --no-cache sed="${SED_VERSION}"

ENTRYPOINT ["sed"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${SED_VERSION}
