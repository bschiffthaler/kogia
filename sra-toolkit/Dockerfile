ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}

ARG SRA_VERSION=2.10.8
ARG GLIBC_VERSION=2.31-r0

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub \
      https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add --no-cache glibc-${GLIBC_VERSION}.apk && \
    rm glibc-${GLIBC_VERSION}.apk

RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRA_VERSION}/sratoolkit.${SRA_VERSION}-ubuntu64.tar.gz && \
    tar -xf sratoolkit.${SRA_VERSION}-ubuntu64.tar.gz && \
    cp -r sratoolkit.${SRA_VERSION}-ubuntu64/bin/* /usr/local/bin && \
    rm -rf sratoolkit*

COPY user-settings.mkfg /root/.ncbi/user-settings.mkfg