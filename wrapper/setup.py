from io import open
from setuptools import find_packages, setup

setup(
    name="ocrd-galley",
    author="Mike Gerber, The QURATOR SPK Team",
    author_email="mike.gerber@sbb.spk-berlin.de, qurator@sbb.spk-berlin.de",
    description="A Dockerized test environment for OCR-D processors ship",
    keywords="qurator ocr ocr-d",
    license="Apache",
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    namespace_packages=["qurator"],
    entry_points={
        "console_scripts": [
            "ocrd=qurator.ocrd_galley.cli:main",
        ]
    },
)
