ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION} AS alpine-build-multiqc

ARG ALPINE_VERSION=3.13
ARG MULTIQC_VERSION=1.11
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
RUN git checkout v4.5.1

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

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-rich.py
RUN echo "datas = copy_metadata('rich')" >> hook-rich.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-dateutil.py
RUN echo "datas = copy_metadata('python-dateutil')" >> hook-dateutil.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-pyparsing.py
RUN echo "datas = copy_metadata('pyparsing')" >> hook-pyparsing.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-cycler.py
RUN echo "datas = copy_metadata('cycler')" >> hook-cycler.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-networkx.py
RUN echo "datas = copy_metadata('networkx')" >> hook-networkx.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-markupsafe.py
RUN echo "datas = copy_metadata('markupsafe')" >> hook-markupsafe.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-humanfriendly.py
RUN echo "datas = copy_metadata('humanfriendly')" >> hook-humanfriendly.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-commonmark.py
RUN echo "datas = copy_metadata('commonmark')" >> hook-commonmark.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-urllib3.py
RUN echo "datas = copy_metadata('urllib3')" >> hook-urllib3.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-colorama.py
RUN echo "datas = copy_metadata('colorama')" >> hook-colorama.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-idna.py
RUN echo "datas = copy_metadata('idna')" >> hook-idna.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" > hook-chardet.py
RUN echo "datas = copy_metadata('chardet')" >> hook-chardet.py

RUN SIX_VERSION=$(python3 -c 'import six; print(six.__version__)') && \
    echo "datas = [('/usr/lib/python${PYTHON_VERSION}/site-packages/six-${SIX_VERSION}-py${PYTHON_VERSION}.egg-info', 'six-${SIX_VERSION}-py${PYTHON_VERSION}.egg-info')]" > hook-six.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-numpy.py
RUN echo "datas = copy_metadata('numpy')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-numpy.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/_pyinstaller_hooks_contrib/hooks/stdhooks/hook-markdown.py
RUN echo "datas = copy_metadata('markdown')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/_pyinstaller_hooks_contrib/hooks/stdhooks/hook-markdown.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-matplotlib.py
RUN echo "datas += copy_metadata('matplotlib')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-matplotlib.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/_pyinstaller_hooks_contrib/hooks/stdhooks/hook-jinja2.py
RUN echo "datas = copy_metadata('jinja2')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/_pyinstaller_hooks_contrib/hooks/stdhooks/hook-jinja2.py

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

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-pygments.py
RUN echo "datas = copy_metadata('pygments')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-pygments.py

RUN echo "from PyInstaller.utils.hooks import collect_submodules" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-packaging.py
RUN echo "hiddenimports += collect_submodules('packaging')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-packaging.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-zipp.py
RUN echo "datas = copy_metadata('zipp')" >> \
    /usr/lib/python${PYTHON_VERSION}/site-packages/PyInstaller/hooks/hook-zipp.py

RUN pyinstaller --additional-hooks-dir . --onefile \
    --add-data /usr/lib/python${PYTHON_VERSION}/site-packages/multiqc:multiqc \
    --hidden-import markdown --hidden-import multiqc --hidden-import packaging \
    --hidden-import rich --hidden-import pygments --hidden-import urllib3 \
    --hidden-import six /usr/bin/multiqc

####
# TESTS
####

RUN mkdir test && \
    wget -P test/ https://bschiffthaler.s3.eu-west-1.amazonaws.com/kogia-tests/wt-1_fastqc.zip
# Rudimentary execution
RUN ./dist/multiqc test

####
# Final image
####

FROM alpine:${ALPINE_VERSION}

ARG MULTIQC_VERSION=1.11

RUN apk add --no-cache bash

WORKDIR /
COPY --from=alpine-build-multiqc /build/dist/multiqc /usr/local/bin/multiqc
ENTRYPOINT ["/usr/local/bin/multiqc"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${MULTIQC_VERSION}
