# FROM https://stackoverflow.com/questions/60298619/awscli-version-2-on-alpine-linux
# 2023-09-07: version 3.18.3 but the python tag is only X.Y
ARG ALPINE_VERSION=3.18
FROM python:alpine${ALPINE_VERSION} as builder

ARG AWS_CLI_VERSION=2.13.16
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN ./configure --with-install-type=portable-exe --with-download-deps
RUN make
RUN make install

# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples
RUN find /usr/local/lib/aws-cli/awscli/data -name completions-1*.json -delete
RUN find /usr/local/lib/aws-cli/awscli/botocore/data -name examples-1.json -delete
RUN (cd /usr/local/lib/aws-cli; for a in *.so*; do test -f /lib/$a && rm $a; done)

# build the final image
FROM alpine:${ALPINE_VERSION}

# RUN apk add --no-cache bash
COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/
RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws

ENTRYPOINT ["/usr/local/bin/aws"]

# one could also just 
# RUN apk update && apk add aws-cli

LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${AWS_CLI_VERSION}
