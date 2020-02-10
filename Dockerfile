#FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04
FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

ENV LEPTONICA_VERSION 1.78.0
ENV TESSERACT_VERSION 4.1.0
ENV TESSDATA_BEST_VERSION 4.0.0
ENV TESSDATA_PREFIX /usr/local/share/tessdata


RUN apt-get update && \
    apt-get install -y \
      curl xz-utils \
      python3-pip \
      git \
# For leptonica/tesseract:
      cmake libgif-dev libjpeg-dev libpng-dev libtiff-dev zlib1g-dev libpango1.0-dev \
# For clstm on Ubuntu 19.04:
      swig libeigen3-dev libpng-dev libprotobuf-dev \
# For cv2:
      libsm6 libxrender1 \
# For ocrd_olena:
      wget graphviz imagemagick libmagick++-dev libgraphicsmagick++1-dev libboost-dev \
# XML utils
      libxml2-utils \
      xmlstarlet \
    && \
    apt-get clean


# Build Leptonica and Tesseract.
RUN curl -sSL -O https://github.com/DanBloomberg/leptonica/releases/download/$LEPTONICA_VERSION/leptonica-$LEPTONICA_VERSION.tar.gz && \
    tar xvzf leptonica-$LEPTONICA_VERSION.tar.gz && \
    cd leptonica-$LEPTONICA_VERSION && \
    mkdir build && cd build && cmake .. && make install && ldconfig && \
    cd ../.. && rm -rf leptonica-$LEPTONICA_VERSION leptonica-$LEPTONICA_VERSION.tar.gz

RUN curl -sSL -O https://github.com/tesseract-ocr/tesseract/archive/$TESSERACT_VERSION.tar.gz && \
    tar xvzf $TESSERACT_VERSION.tar.gz && \
    cd tesseract-$TESSERACT_VERSION && \
    mkdir build && cd build && cmake .. && make install && ldconfig && \
    cd ../.. && rm -rf tesseract-$TESSERACT_VERSION $TESSERACT_VERSION.tar.gz

RUN curl -sSL -O https://github.com/tesseract-ocr/tessdata_best/archive/$TESSDATA_BEST_VERSION.tar.gz && \
    tar xvzf $TESSDATA_BEST_VERSION.tar.gz && \
    mv tessdata_best-$TESSDATA_BEST_VERSION $TESSDATA_PREFIX && \
    rm -rf $TESSDATA_BEST_VERSION.tar.gz


# Set up OCR-D logging
COPY ocrd_logging.py /etc/


# Build ocrd_olena
RUN pip3 install --no-cache-dir --upgrade pip && \
   curl -sSL -o ocrd_olena.tar.gz https://github.com/OCR-D/ocrd_olena/archive/fde4436.tar.gz && \
   mkdir ocrd_olena && \
   tar xvz -C ocrd_olena --strip-components=1 -f ocrd_olena.tar.gz && \
   cd ocrd_olena && \
   make install PREFIX=/usr/local && \
   cd .. && rm -rf ocrd_olena ocrd_olena.tar.gz


# Copy OCR models
RUN mkdir -p /var/lib/calamari-models
COPY data/calamari-models/GT4HistOCR /var/lib/calamari-models/GT4HistOCR
RUN mkdir -p $TESSDATA_PREFIX
COPY data/tesseract-models/GT4HistOCR/GT4HistOCR_2000000.traineddata $TESSDATA_PREFIX/
COPY data/textline_detection /var/lib/textline_detection

RUN tesseract --list-langs


# Install requirements
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    pip3 check

COPY my_ocrd_workflow /usr/bin/
COPY xsd/*            /usr/share/xml/


# XXX Work around suspected concurrency problems in ocrd-sbb-textline-detector
RUN sed -i 's#num_cores *= *cpu_count()#num_cores = 1#' /usr/local/lib/python3.6/dist-packages/qurator/sbb_textline_detector/main.py


WORKDIR /data
CMD ["/usr/bin/my_ocrd_workflow"]
