FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

ENV OCRD_OLENA_VERSION 1.1.10
ENV TESSDATA_BEST_VERSION 4.0.0
ENV TESSDATA_PREFIX /usr/local/share/tessdata


RUN apt-get update && \
    apt-get install -y \
      curl xz-utils \
      python3-pip \
      git \
      software-properties-common \
# For clstm on Ubuntu 19.04:
      swig libeigen3-dev libpng-dev libprotobuf-dev \
# For cv2:
      libsm6 libxrender1 \
# For ocrd_olena:
      imagemagick \
# XML utils
      libxml2-utils \
      xmlstarlet \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Install Leptonica and Tesseract.
RUN add-apt-repository ppa:alex-p/tesseract-ocr && \
    apt-get update && \
    apt-get install -y \
        tesseract-ocr \
        libtesseract-dev \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up OCR-D logging
COPY ocrd_logging.py /etc/


# Build ocrd_olena
# XXX .deb needs an update
RUN curl -sSL -O https://qurator-data.de/~mike.gerber/olena_2.1-0+ocrd-git/olena-bin_2.1-0+ocrd-git_amd64.deb && \
    dpkg -i --force-depends olena-bin_2.1-0+ocrd-git_amd64.deb && \
    rm -f olena-bin_2.1-0+ocrd-git_amd64.deb && \
    apt-get update && \
    apt-get -f install -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir --upgrade pip && \
   curl -sSL -o ocrd_olena.tar.gz https://github.com/OCR-D/ocrd_olena/archive/v${OCRD_OLENA_VERSION}.tar.gz && \
   mkdir ocrd_olena && \
   tar xvz -C ocrd_olena --strip-components=1 -f ocrd_olena.tar.gz && \
   cd ocrd_olena && \
   sed -i 's/^install: deps$/install:/' Makefile && \
   pip3 install --no-cache-dir ocrd && \
   make install PREFIX=/usr/local && \
   cd .. && rm -rf ocrd_olena ocrd_olena.tar.gz


# Copy OCR models
RUN mkdir -p /var/lib/calamari-models
COPY data/calamari-models/GT4HistOCR /var/lib/calamari-models/GT4HistOCR
RUN mkdir -p $TESSDATA_PREFIX
RUN curl -sSL -O https://qurator-data.de/mirror/github.com/tesseract-ocr/tessdata_best/archive/$TESSDATA_BEST_VERSION.tar.gz && \
    tar xzf $TESSDATA_BEST_VERSION.tar.gz && \
    mv tessdata_best-$TESSDATA_BEST_VERSION/* $TESSDATA_PREFIX/ && \
    rm -rf $TESSDATA_BEST_VERSION.tar.gz
COPY data/tesseract-models/GT4HistOCR/GT4HistOCR_2000000.traineddata $TESSDATA_PREFIX/
COPY data/textline_detection /var/lib/textline_detection


# Install requirements
# Using pipdeptree here to get more info than from pip3 check
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    pip3 install --no-cache-dir pipdeptree && \
    pipdeptree -w fail


COPY my_ocrd_workflow /usr/bin/
COPY xsd/*            /usr/share/xml/


WORKDIR /data
ENTRYPOINT ["/usr/bin/my_ocrd_workflow"]
