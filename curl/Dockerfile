ARG CURL_VERSION=7.72.0

FROM curlimages/curl:${CURL_VERSION}

USER root
RUN apk add --no-cache bash
USER curl_user

ENTRYPOINT ["curl"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${CURL_VERSION}
