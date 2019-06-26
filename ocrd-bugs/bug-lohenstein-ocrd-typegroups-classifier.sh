#!/bin/bash -x
cd `mktemp -d`
wget https://ocr-d-repo.scc.kit.edu/api/v1/dataresources/8d8aa287-94ca-48e3-84a8-1ee602871550/data/lohenstein_agrippina_1665.ocrd.zip
dtrx lohenstein_agrippina_1665.ocrd.zip
cd lohenstein_agrippina_1665.ocrd/data
ocrd_typegroups_classifier_parameters='
  {
    "network": "/home/mike/devel/OCR-D/monorepo/ocrd_typegroups_classifier/ocrd_typegroups_classifier/models/classifier.tgc",
    "stride":143
  }'
ocrd-typegroups-classifier -l DEBUG \
  -m mets.xml -I OCR-D-IMG -O OCR-D-FONTIDENT \
  -p <(echo $ocrd_typegroups_classifier_parameters)
