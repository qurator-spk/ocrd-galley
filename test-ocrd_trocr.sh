#!/bin/sh
set -ex

cd `mktemp -d /tmp/test-ocrd_trocr-XXXXX`

# Prepare processors

# Prepare test workspace
wget https://qurator-data.de/examples/actevedef_718448162.first-page+binarization+segmentation.zip
unzip actevedef_718448162.first-page+binarization+segmentation.zip
cd actevedef_718448162.first-page+binarization+segmentation

# Run tests
ocrd-trocr-recognize      -I OCR-D-SEG-LINE-SBB -O TEST-TROCR
