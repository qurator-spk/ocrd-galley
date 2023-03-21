from io import open
from setuptools import find_packages, setup

from qurator.ocrd_galley.sub_images import sub_images
console_scripts = ["%s=qurator.ocrd_galley.cli:main" % command for command in sub_images.keys()]

with open("requirements.txt") as fp:
    install_requires = fp.read()

setup(
    name="ocrd-galley",
    author="Mike Gerber, The QURATOR SPK Team",
    author_email="mike.gerber@sbb.spk-berlin.de, qurator@sbb.spk-berlin.de",
    description="A Dockerized test environment for OCR-D processors ship",
    keywords="qurator ocr ocr-d",
    license="Apache",
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    namespace_packages=["qurator"],
    install_requires=install_requires,
    entry_points={
        "console_scripts": console_scripts,
    },
)
