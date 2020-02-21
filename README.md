My OCR-D workflow
=================

[![Build Status](https://travis-ci.org/mikegerber/my_ocrd_workflow.svg?branch=master)](https://travis-ci.org/mikegerber/my_ocrd_workflow)

WIP. Given a OCR-D workspace with document images in the OCR-D-IMG file group,
this workflow produces:

* Binarized images
* Line segmentation
* OCR text (using Calamari and Tesseract, both with GT4HistOCR models)
* (Given ground truth in OCR-D-GT-PAGE, also an OCR text evaluation report)

If you're interested in the exact processors, versions and parameters, please take a look at the [script](my_ocrd_workflow) and possibly the [Dockerfile](Dockerfile) and the [requirements](requirements.txt).

Goal
----
Provide an environment to produce OCR output using OCR-D, especially [ocrd_calamari](https://github.com/OCR-D/ocrd_calamari) and [sbb_textline_detection](https://github.com/qurator-spk/sbb_textline_detection), including all dependencies in Docker.

How to use
----------
It's easiest to use it as a container. To build the container using Docker:
~~~
cd ~/devel/my_ocrd_workflow
./build
~~~

To run the container on an example workspace:
~~~
# Download an example workspace
cd /tmp
wget https://qurator-data.de/examples/actevedef_718448162.first-page.zip
unzip actevedef_718448162.first-page.zip

# Run the workflow on it
cd actevedef_718448162.first-page
~/devel/my_ocrd_workflow/run
~~~

### Viewing results
You may then examine the results using
[PRImA's PAGE Viewer](https://www.primaresearch.org/tools/PAGEViewer):
~~~
java -jar /path/to/JPageViewer.jar --resolve-dir . OCR-D-OCR-CALAMARI/OCR-D-OCR-CALAMARI_00000024.xml
~~~

The workflow also produces OCR evaluation reports using
[dinglehopper](https://github.com/qurator-spk/dinglehopper), if ground truth was
available:
~~~
firefox OCR-D-OCR-CALAMARI-EVAL/OCR-D-OCR-CALAMARI-EVAL_00000024.html
~~~
