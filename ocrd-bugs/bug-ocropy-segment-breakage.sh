# zips all from https://ocr-d-repo.scc.kit.edu/api/v1/metastore/bagit
for z in benner_herrnhuterey04_1748.ocrd.zip buerger_gedichte_1778.ocrd.zip estor_rechtsgelehrsamkeit02_1758.ocrd.zip lohenstein_agrippina_1665.ocrd.zip silesius_seelenlust01_1657.ocrd.zip; do
  echo "== $z"
  cd `mktemp -d`
  cp /srv/data/OCR-D/$z .
  dtrx $z
  cd ${z//.zip}/data

  ocrd-ocropy-segment -l DEBUG -m mets.xml -I OCR-D-IMG -O OCR-D-SEG-LINE 2>&1 | tail -n 1
done
