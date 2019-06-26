#!/bin/sh
set -x
cd `mktemp -d`
wget -q https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/f15fb8c8-3842-4314-9a44-5e8b472d7bfc/data/buerger_gedichte_1778.ocrd.zip
dtrx buerger_gedichte_1778.ocrd.zip
cd buerger_gedichte_1778.ocrd/data
ocrd workspace validate mets.xml
