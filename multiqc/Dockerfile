ARG DEBIAN_VERSION=bullseye

FROM python:3.8-slim-${DEBIAN_VERSION} AS build-multiqc

ARG MULTIQC_VERSION=1.34

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git wget ca-certificates binutils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN pip3 install --upgrade pip
RUN pip3 install multiqc==${MULTIQC_VERSION}
RUN pip3 install pyinstaller

RUN pyinstaller --onefile \
    --collect-all multiqc \
    --collect-all matplotlib \
    --collect-all plotly \
    --collect-all kaleido \
    --collect-submodules packaging \
    /usr/local/bin/multiqc

# Test
RUN mkdir test && \
    wget -P test/ https://bschiffthaler.s3.eu-west-1.amazonaws.com/kogia-tests/wt-1_fastqc.zip
RUN ./dist/multiqc test

# Final build
FROM debian:${DEBIAN_VERSION}-slim

ARG MULTIQC_VERSION=1.34

COPY --from=build-multiqc /build/dist/multiqc /usr/local/bin/multiqc
ENTRYPOINT ["/usr/local/bin/multiqc"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${MULTIQC_VERSION}