ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-cutadapt
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
ARG ALPINE_VERSION=3.12
ARG CUTADAPT_VERSION=2.10
RUN apk update && apk add build-base zlib-dev libexecinfo-dev \
    bzip2-dev xz-dev python3 py3-setuptools py3-pip git python3-dev
WORKDIR /build

RUN pip3 install wheel Cython
RUN git clone https://github.com/marcelm/cutadapt.git
WORKDIR /build/cutadapt
# We want to install a specific version so we switch to that git branch
RUN git checkout v${CUTADAPT_VERSION}
RUN python3 setup.py install

# Now we set up PyInstaller with a custom bootloader because alpine things
# (i.e. MUSL C doesnt have some functionality that the default bootloader)
# expects
WORKDIR /build
RUN git clone https://github.com/pyinstaller/pyinstaller
WORKDIR /build/pyinstaller/bootloader
RUN CFLAGS="-Wno-stringop-overflow" python3 ./waf configure --no-lsb all && \
    pip3 install ..
WORKDIR /build

# Setup some python dependencies for cutadapt so that also PyInst knows about it
WORKDIR /build/tmp
RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-cutadapt.py
RUN echo "datas = copy_metadata('cutadapt')" >> hook-cutadapt.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-xopen.py
RUN echo "datas = copy_metadata('xopen')" >> hook-xopen.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-dnaio.py
RUN echo "datas = copy_metadata('dnaio')" >> hook-dnaio.py
# Build with pyinst
RUN pyinstaller --additional-hooks-dir . --onefile \
    --hidden-import setuptools --hidden-import packaging.version \
    --hidden-import packaging.requirements --hidden-import cutadapt \
    --hidden-import xopen --hidden-import dnaio \
    --hidden-import cutadapt.__main__ \
    $(which cutadapt)

RUN strip /build/tmp/dist/cutadapt

FROM alpine:${ALPINE_VERSION}
ARG CUTADAPT_VERSION=2.10

COPY --from=alpine-build-cutadapt /build/tmp/dist/cutadapt /usr/local/bin/cutadapt

ENTRYPOINT ["/usr/local/bin/cutadapt"]
LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${CUTADAPT_VERSION}
