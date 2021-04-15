ARG ALPINE_VERSION=3.12
# Build image
FROM alpine:${ALPINE_VERSION} AS alpine-build-demultiplex
ARG ALPINE_VERSION=3.12
ARG DEMULTIPLEX_VERSION=1.2.1
ARG PY_VERSION=3.8
ARG TSSV=1.0.5
ARG FASTOOLS=1.0.2
ARG JIT_OPEN=1.0.1

RUN apk update && apk add build-base zlib-dev libexecinfo-dev \
    bzip2-dev xz-dev python3 py3-setuptools py3-pip git python3-dev \
    py3-wheel py3-numpy openblas-dev gcc g++ gfortran
RUN pip3 install cython
WORKDIR /build

RUN git clone https://github.com/jfjlaros/demultiplex
WORKDIR /build/demultiplex
RUN git checkout v${DEMULTIPLEX_VERSION}
# We want to install a specific version so we switch to that git branch
RUN python3 setup.py install
RUN cp -r demultiplex.egg-info /usr/lib/python${PY_VERSION}/site-packages/demultiplex-${DEMULTIPLEX_VERSION}-py${PY_VERSION}.egg-info


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

RUN echo "from PyInstaller.utils.hooks import collect_all" > hook-demultiplex.py
RUN echo "datas, binaries, hiddenimports = collect_all('demultiplex')" >> hook-demultiplex.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-fastools.py
RUN echo "datas = copy_metadata('fastools')" >> hook-fastools.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-jit_open.py
RUN echo "datas = copy_metadata('jit_open')" >> hook-jit_open.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-tssv.py
RUN echo "datas = copy_metadata('tssv')" >> hook-tssv.py

# Annoying but needs doing - UPDATE THE link to dl
RUN wget https://files.pythonhosted.org/packages/55/d0/8fd40faa3f568529ec06118c120359eed9fdcb0f291e674c037857a55c2c/jit_open-${JIT_OPEN}.tar.gz && \
tar -zxf jit_open-${JIT_OPEN}.tar.gz && cp -r jit_open-${JIT_OPEN}/jit_open.egg-info /usr/lib/python${PY_VERSION}/site-packages/jit_open-${JIT_OPEN}-py${PY_VERSION}.egg-info

RUN wget https://files.pythonhosted.org/packages/31/7d/754eaadf1ddd18c77d07544193d7691e3291063df62292cf3465d070bb09/tssv-${TSSV}.tar.gz && \
tar -zxf tssv-${TSSV}.tar.gz && cp -r tssv-${TSSV}/tssv.egg-info /usr/lib/python${PY_VERSION}/site-packages/tssv-${TSSV}-py${PY_VERSION}.egg-info

# Build with pyinst
RUN pyinstaller --additional-hooks-dir . --onefile \
--add-data /usr/lib/python${PY_VERSION}/site-packages/demultiplex-${DEMULTIPLEX_VERSION}-py${PY_VERSION}.egg-info:demultiplex \
--add-data /usr/lib/python${PY_VERSION}/site-packages/fastools-${FASTOOLS}-py${PY_VERSION}.egg:fastools \
--add-data /usr/lib/python${PY_VERSION}/site-packages/jit_open-${JIT_OPEN}-py${PY_VERSION}.egg-info:jit_open \
--add-data /usr/lib/python${PY_VERSION}/site-packages/tssv-${TSSV}-py${PY_VERSION}-linux-x86_64.egg:tssv \
--hidden-import jit_open --hidden-import pkg_resources --hidden-import tssv \
--hidden-import fastools --hidden-import demultiplex \
$(which demultiplex)

RUN strip /build/tmp/dist/demultiplex

FROM alpine:${ALPINE_VERSION}
ARG DEMULTIPLEX_VERSION=1.2.1

COPY --from=alpine-build-demultiplex /build/tmp/dist/demultiplex /usr/local/bin/demultiplex

ENTRYPOINT ["/usr/local/bin/demultiplex"]
LABEL maintainer='github.com/nicolasDelhomme'
LABEL software.version=${DEMULTIPLEX_VERSION}
