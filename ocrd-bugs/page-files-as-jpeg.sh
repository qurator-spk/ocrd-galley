#!/bin/sh
# Most/All workspaces in bag files don't validate
# https://github.com/OCR-D/assets/issues/63

set -e

cd `mktemp -d`
virtualenv venv
. venv/bin/activate
pip install --pre ocrd

wget https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/558280e0-c40a-49ae-81ab-679bc29567c3/data/gerstner_mechanik01_1831.zip
dtrx gerstner_mechanik01_1831.zip

cd gerstner_mechanik01_1831/data
ocrd workspace validate mets.xml
