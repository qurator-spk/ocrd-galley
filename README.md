My OCR-D workflow
=================

[![Build Status](https://travis-ci.org/mikegerber/my_ocrd_workflow.svg?branch=master)](https://travis-ci.org/mikegerber/my_ocrd_workflow)

WIP.

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

You may then examine the results using
[PRImA's PAGE Viewer](https://www.primaresearch.org/tools/PAGEViewer):
~~~
java -jar /path/to/JPageViewer.jar --resolve-dir . OCR-D-OCR-CALAMARI/OCR-D-OCR-CALAMARI_00000024.xml
~~~

The workflow also produces OCR evaluation reports using
[dinglehopper](https://github.com/qurator-spk/dinglehopper), if ground truth was
available in a OCR-D-GT-PAGE file group:
~~~
firefox OCR-D-OCR-CALAMARI-EVAL/OCR-D-OCR-CALAMARI-EVAL_00000024.html
~~~
