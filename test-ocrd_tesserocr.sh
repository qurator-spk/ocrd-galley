#!/bin/sh
set -ex

cd `mktemp -d /tmp/test-ocrd_tesserocr-XXXXX`

# Prepare processors
ocrd resmgr download ocrd-tesserocr-recognize Fraktur_GT4HistOCR.traineddata

# Prepare test workspace
wget https://qurator-data.de/examples/actevedef_718448162.first-page+binarization+segmentation.zip
unzip actevedef_718448162.first-page+binarization+segmentation.zip
cd actevedef_718448162.first-page+binarization+segmentation

# Run tests
ocrd-tesserocr-segment-region -I OCR-D-IMG-BIN      -O TEST-TESS-SEG-REG
ocrd-tesserocr-segment-line   -I TEST-TESS-SEG-REG  -O TEST-TESS-SEG-LINE
ocrd-tesserocr-recognize      -I TEST-TESS-SEG-LINE -O TEST-TESS-OCR       -P model Fraktur_GT4HistOCR
