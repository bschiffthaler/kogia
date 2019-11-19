FROM alpine AS alpine-build-salmon

RUN apk update && apk add python3 build-base zlib-dev libpng-dev freetype-dev \
    libc6-compat python3-dev git

WORKDIR /build

RUN pip3 install multiqc

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
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-numpy.py
RUN echo "datas = copy_metadata('numpy')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-numpy.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-markdown.py
RUN echo "datas = copy_metadata('markdown')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-markdown.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-matplotlib.py
RUN echo "datas += copy_metadata('matplotlib')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-matplotlib.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-jinja2.py
RUN echo "datas = copy_metadata('jinja2')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-jinja2.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-pytz.py
RUN echo "datas += copy_metadata('pytz')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-pytz.py

RUN echo "from PyInstaller.utils.hooks import copy_metadata" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-setuptools.py
RUN echo "datas = copy_metadata('setuptools')" >> \
    /usr/lib/python3.7/site-packages/PyInstaller/hooks/hook-setuptools.py

RUN pyinstaller --additional-hooks-dir . --onefile \
    --add-data /usr/lib/python3.7/site-packages/multiqc:multiqc \
    --hidden-import markdown $(which multiqc)

FROM alpine 
WORKDIR / 
COPY --from=alpine-build-salmon /build/dist/multiqc /usr/local/bin/multiqc
ENTRYPOINT ["/usr/local/bin/multiqc"]