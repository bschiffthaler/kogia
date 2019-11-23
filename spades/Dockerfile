FROM alpine AS alpine-build-spades
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add wget

RUN mkdir /build
WORKDIR /build

RUN wget http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz

RUN tar -xf SPAdes-3.13.0-Linux.tar.gz

FROM alpine 
WORKDIR / 
RUN apk add --no-cache python3 libc6-compat && \
    ln -s $(which python3) /usr/local/bin/python && \
    mkdir /usr/local/share/spades
COPY --from=alpine-build-spades /build/SPAdes-3.13.0-Linux/bin/* /usr/local/bin
COPY --from=alpine-build-spades /build/SPAdes-3.13.0-Linux/share/* /usr/local/share/spades

ENTRYPOINT ["/usr/local/bin/spades.py"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='3.13.0'