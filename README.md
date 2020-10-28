ocrd-galley
===========

[![Build Status](https://travis-ci.com/qurator-spk/ocrd-galley.svg?branch=master)](https://travis-ci.com/qurator-spk/ocrd-galley)

A Dockerized test environment for OCR-D processors 🚢

WIP. Given a OCR-D workspace with document images in the OCR-D-IMG file group,
this workflow produces:

* Binarized images
* Line segmentation
* OCR text (using Calamari and Tesseract, both with GT4HistOCR models)
* (Given ground truth in OCR-D-GT-PAGE, also an OCR text evaluation report)

If you're interested in the exact processors, versions and parameters, please
take a look at the [script](my_ocrd_workflow) and possibly the individual
Dockerfiles.

Goal
----
Provide a **test environment** to produce OCR output for historical prints,
using OCR-D, especially [ocrd_calamari](https://github.com/OCR-D/ocrd_calamari)
and
[sbb_textline_detection](https://github.com/qurator-spk/sbb_textline_detection),
including all dependencies in Docker.

How to use
----------
It's easiest to use it as pre-built containers. To run the containers on an
example workspace:

~~~
# Update to the latest stable containers
(cd ~/devel/my_ocrd_workflow/; ./run-docker-hub-update)

# Download an example workspace
cd /tmp
wget https://qurator-data.de/examples/actevedef_718448162.first-page.zip
unzip actevedef_718448162.first-page.zip

# Run the workflow on it
cd actevedef_718448162.first-page
~/devel/my_ocrd_workflow/run-docker-hub
~~~

### Build the containers yourself
To build the containers yourself using Docker:
~~~
cd ~/devel/my_ocrd_workflow
./build
~~~
You may then use the script `run` to use your self-built containers, analogous to
the example above.

### Viewing results
You may then examine the results using
[PRImA's PAGE Viewer](https://www.primaresearch.org/tools/PAGEViewer):
~~~
java -jar /path/to/JPageViewer.jar \
  --resolve-dir . \
  OCR-D-OCR-CALAMARI/OCR-D-OCR-CALAMARI_00000024.xml
~~~

The workflow also produces OCR evaluation reports using
[dinglehopper](https://github.com/qurator-spk/dinglehopper), if ground truth was
available:
~~~
firefox OCR-D-OCR-CALAMARI-EVAL/OCR-D-OCR-CALAMARI-EVAL_00000024.html
~~~

ppn2ocr
-------
The `ppn2ocr` script produces a workspace and METS file with the best images for
a given document in the State Library Berlin (SBB)'s digitized collection.

Install it with an up-to-date pip (otherwise this will fail due to [a opencv-python-headless build failure](https://github.com/skvark/opencv-python#frequently-asked-questions)):
~~~
pip install -r ~/devel/my_ocrd_workflow/requirements-ppn2ocr.txt
~~~

The document must be specified by its PPN, for example:
~~~
~/devel/my_ocrd_workflow/ppn2ocr PPN77164308X
cd PPN77164308X
~/devel/my_ocrd_workflow/run-docker-hub -I BEST --skip-validation
~~~

This produces a workspace directory `PPN77164308X` with the OCR results in it;
the results are viewable as explained above.

ppn2ocr requires properly set up environment variables for the proxy
configuration. At SBB, please read `howto/docker-proxy.md` and
`howto/proxy-settings-for-shell+python.md` (in qurator's mono-repo).

ocrd-workspace-from-images
--------------------------
The `ocrd-workspace-from-images` script produces a OCR-D workspace (incl. METS)
for the given images.

~~~
~/devel/my_ocrd_workflow/ocrd-workspace-from-images 0005.png
cd workspace-xxxxx  # output by the last command
~/devel/my_ocrd_workflow/run-docker-hub
~~~

This produces a workspace from the files and then runs the OCR workflow on it.
