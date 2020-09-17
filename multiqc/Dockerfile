ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS alpine-build-multiqc

ARG ALPINE_VERSION=3.12
ARG MULTIQC_VERSION=1.9
ARG PYTHON_VERSION=3.8

RUN apk update && apk add python3 build-base zlib-dev libpng-dev freetype-dev \
    libc6-compat python3-dev py3-pip py3-wheel ipython py3-tornado \
    cython py3-jinja2 py3-future git jpeg-dev

WORKDIR /build

RUN pip3 install --upgrade pip
RUN pip3 install matplotlib==3.0.3
RUN pip3 install multiqc==${MULTIQC_VERSION}

RUN git clone https://github.com/pyinstaller/pyinstaller

WORKDIR /build/pyinstaller/bootloader

RUN CFLAGS="-Wno-stringop-overflow" python3 ./waf configure --no-lsb all && \
    pip3 install ..

WORKDIR /build

## Setup copying a whole lot of package metadata for pyinstaller...

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-multiqc.py
RUN echo "datas = copy_metadata('multiqc')" >> hook-multiqc.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-spectra.py
RUN echo "datas = copy_metadata('spectra')" >> hook-spectra.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-simplejson.py
RUN echo "datas = copy_metadata('simplejson')" >> hook-simplejson.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-requests.py
RUN echo "datas = copy_metadata('requests')" >> hook-requests.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-yaml.py
RUN echo "datas = copy_metadata('pyyaml')" >> hook-yaml.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-lzstring.py
RUN echo "datas = copy_metadata('lzstring')" >> hook-lzstring.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-future.py
RUN echo "datas = copy_metadata('future')" >> hook-future.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-click.py
RUN echo "datas = copy_metadata('click')" >> hook-click.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-colormath.py
RUN echo "datas = copy_metadata('colormath')" >> hook-colormath.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-kiwisolver.py
RUN echo "datas = copy_metadata('kiwisolver')" >> hook-kiwisolver.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-six.py
RUN echo "datas = copy_metadata('six')" >> hook-six.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-dateutil.py
RUN echo "datas = copy_metadata('python-dateutil')" >> hook-dateutil.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-pyparsing.py
RUN echo "datas = copy_metadata('pyparsing')" >> hook-pyparsing.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-cycler.py
RUN echo "datas = copy_metadata('cycler')" >> hook-cycler.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-networkx.py
RUN echo "datas = copy_metadata('networkx')" >> hook-networkx.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-numpy.py
RUN echo "datas = copy_metadata('numpy')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-numpy.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-markdown.py
RUN echo "datas = copy_metadata('markdown')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-markdown.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-matplotlib.py
RUN echo "datas += copy_metadata('matplotlib')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-matplotlib.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-jinja2.py
RUN echo "datas = copy_metadata('jinja2')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-jinja2.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-pytz.py
RUN echo "datas += copy_metadata('pytz')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-pytz.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-setuptools.py
RUN echo "datas = copy_metadata('setuptools')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-setuptools.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-coloredlogs.py
RUN echo "datas = copy_metadata('coloredlogs')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-coloredlogs.py

RUN pyinstaller --additional-hooks-dir . --onefile \
    --add-data /usr/lib/python${PYTHON_VERSION}/site-packages/multiqc:multiqc \
    --hidden-import markdown --hidden-import multiqc --hidden-import packaging.requirements \
    $(which multiqc)

FROM alpine:${ALPINE_VERSION}

ARG MULTIQC_VERSION=1.9

RUN apk add --no-cache bash

WORKDIR / 
COPY --from=alpine-build-multiqc /build/dist/multiqc /usr/local/bin/multiqc
ENTRYPOINT ["/usr/local/bin/multiqc"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${MULTIQC_VERSION}
