ARG ALPINE_VERSION=3.12
# Final exec image
FROM alpine:${ALPINE_VERSION}
ARG AWK_VERSION=5.1.0-r0

WORKDIR / 
RUN apk add --no-cache bash
RUN apk add --no-cache gawk="${AWK_VERSION}"

ENTRYPOINT ["gawk"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${AWK_VERSION}
