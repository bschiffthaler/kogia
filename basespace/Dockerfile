ARG FEDORA_VERSION=32

FROM registry.fedoraproject.org/fedora-minimal:${FEDORA_VERSION}

ARG BASESPACE_VERSION=1.2.1

RUN microdnf install wget findutils python3 && microdnf clean all

RUN wget -O /usr/local/bin/bs \
      "https://bintray.com/basespace/BaseSpaceCLI-EarlyAccess-BIN/download_file?file_path=latest%2F${BASESPACE_VERSION}%2Famd64-linux%2Fbs"

RUN chmod +x /usr/local/bin/bs

ENTRYPOINT ["bs"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${BASESPACE_VERSION}
