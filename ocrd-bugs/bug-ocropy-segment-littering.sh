#!/bin/bash -x
cd `mktemp -d`

virtualenv -p /usr/bin/python3 venv
. venv/bin/activate
pip install ocrd-ocropy

wget https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/1b0fb8b5-3397-4c99-9ec3-24d5954ac0fb/data/bernd_lebensbeschreibung_1738.ocrd.zip
dtrx bernd_lebensbeschreibung_1738.ocrd.zip

cd bernd_lebensbeschreibung_1738.ocrd/data
ocrd-ocropy-segment -m mets.xml -I OCR-D-IMG -O OCR-D-SEG-LINES

pip list | grep ocrd
ls -l
