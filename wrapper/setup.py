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
            "ocrd-olena-binarize=qurator.ocrd_galley.cli:main",
            "ocrd-sbb-binarize=qurator.ocrd_galley.cli:main",
            "ocrd-sbb-textline-detector=qurator.ocrd_galley.cli:main",
            "ocrd-calamari-recognize=qurator.ocrd_galley.cli:main",
            "ocrd-calamari-recognize-feat-update-calamari1=qurator.ocrd_galley.cli:main",
            "ocrd-tesserocr-segment-region=qurator.ocrd_galley.cli:main",
            "ocrd-tesserocr-segment-line=qurator.ocrd_galley.cli:main",
            "ocrd-tesserocr-recognize=qurator.ocrd_galley.cli:main",
            "ocrd-dinglehopper=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-clip=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-resegment=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-segment=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-deskew=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-denoise=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-binarize=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-dewarp=qurator.ocrd_galley.cli:main",
            "ocrd-cis-ocropy-recognize=qurator.ocrd_galley.cli:main",
            "ocrd-fileformat-transform=qurator.ocrd_galley.cli:main",
        ]
    },
)
