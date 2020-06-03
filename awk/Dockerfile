ARG ALPINE_VERSION=3.11
# Final exec image
FROM alpine:${ALPINE_VERSION}
ARG AWK_VERSION=5.0.1-r0

WORKDIR / 

RUN apk update --no-cache && apk add --no-cache gawk="${AWK_VERSION}"

ENTRYPOINT ["gawk"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${AWK_VERSION}
