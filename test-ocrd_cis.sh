#!/bin/sh
set -ex

test_name=`basename $0`
cd `mktemp -d /tmp/test-$test_name-XXXXX`

# Prepare test workspace
wget https://qurator-data.de/examples/actevedef_718448162.first-page+binarization+segmentation.zip
unzip actevedef_718448162.first-page+binarization+segmentation.zip
cd actevedef_718448162.first-page+binarization+segmentation

# Run tests
ocrd-cis-ocropy-segment -I OCR-D-IMG-BIN -O TEST-CIS-OCRPY-SEGMENT
# TODO -recognize
