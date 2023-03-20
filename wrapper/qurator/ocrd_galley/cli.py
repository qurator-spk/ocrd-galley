import os
import subprocess
import sys
import colorama
from pathlib import Path
from termcolor import colored


DOCKER_IMAGE_PREFIX = os.environ.get("DOCKER_IMAGE_PREFIX", "quratorspk/ocrd-galley")
DOCKER_IMAGE_TAG = os.environ.get("DOCKER_IMAGE_TAG", "latest")
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

# xdg-user-dirs is only available under Python 3.10+ etc. pp. → it is simpler
# to just roll it on our own.
XDG_CONFIG_HOME = os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")
XDG_DATA_HOME = os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share")


sub_images = {
        "ocrd": "core",
        "ocrd-olena-binarize": "ocrd_olena",
        "ocrd-sbb-binarize": "sbb_binarization",
        "ocrd-sbb-textline-detector": "sbb_textline_detector",
        "ocrd-calamari-recognize": "ocrd_calamari",
        "ocrd-calamari-recognize03": "ocrd_calamari03",
        "ocrd-tesserocr-segment-region": "ocrd_tesserocr",
        "ocrd-tesserocr-segment-line": "ocrd_tesserocr",
        "ocrd-tesserocr-recognize": "ocrd_tesserocr",
        "ocrd-dinglehopper": "dinglehopper",
        "ocrd-cis-ocropy-clip": "ocrd_cis",
        "ocrd-cis-ocropy-resegment": "ocrd_cis",
        "ocrd-cis-ocropy-segment": "ocrd_cis",
        "ocrd-cis-ocropy-deskew": "ocrd_cis",
        "ocrd-cis-ocropy-denoise": "ocrd_cis",
        "ocrd-cis-ocropy-binarize": "ocrd_cis",
        "ocrd-cis-ocropy-dewarp": "ocrd_cis",
        "ocrd-cis-ocropy-recognize": "ocrd_cis",
        "ocrd-fileformat-transform": "ocrd_fileformat",
        "ocrd-segment-extract-pages": "ocrd_segment",
        "ocrd-segment-extract-regions": "ocrd_segment",
        "ocrd-segment-extract-lines": "ocrd_segment",
        "ocrd-segment-from-masks": "ocrd_segment",
        "ocrd-segment-from-coco": "ocrd_segment",
        "ocrd-segment-repair": "ocrd_segment",
        "ocrd-segment-evaluate": "ocrd_segment",
        "ocrd-preprocess-image": "ocrd_wrap",
        "ocrd-skimage-normalize": "ocrd_wrap",
        "ocrd-skimage-denoise-raw": "ocrd_wrap",
        "ocrd-skimage-binarize": "ocrd_wrap",
        "ocrd-skimage-denoise": "ocrd_wrap",
        "ocrd-eynollah-segment": "eynollah",
        "ocrd-anybaseocr-crop": "ocrd_anybaseocr",
        "ocrd-anybaseocr-deskew": "ocrd_anybaseocr",

        # non OCR-D CLI
        "ocr-transform": "ocrd_fileformat",
}


def main():
    colorama.init()

    argv = sys.argv.copy()
    argv[0] = os.path.basename(argv[0])

    sub_image = sub_images[argv[0]]
    docker_image = "%s-%s:%s" % (DOCKER_IMAGE_PREFIX, sub_image, DOCKER_IMAGE_TAG)

    if DOCKER_IMAGE_TAG != "latest":
        print(colored(f"Using {docker_image}", 'red'))
    docker_run(argv, docker_image)


def docker_run(argv, docker_image):
    docker_run_options = []
    docker_run_options.extend(["--rm", "-t"])
    docker_run_options.extend(["--mount", "type=bind,src=%s,target=/data" % os.getcwd()])
    docker_run_options.extend(["--user", "%s:%s" % (os.getuid(), os.getgid())])
    docker_run_options.extend(["-e", "LOG_LEVEL=%s" % LOG_LEVEL])
    docker_run_options.extend(["-e", "_OCRD_COMPLETE"])

    docker_run_options.extend(["-e", "XDG_CONFIG_HOME=%s" % XDG_CONFIG_HOME])
    docker_run_options.extend(["--mount", "type=bind,src=%s,target=%s" %
        (XDG_CONFIG_HOME, XDG_CONFIG_HOME)])
    docker_run_options.extend(["-e", "XDG_DATA_HOME=%s" % XDG_DATA_HOME])
    docker_run_options.extend(["--mount", "type=bind,src=%s,target=%s" %
        (XDG_DATA_HOME, XDG_DATA_HOME)])

    # JAVA_TOOL_OPTIONS is used for Java proxy settings
    if os.environ.get("JAVA_TOOL_OPTIONS"):
        docker_run_options.extend(["-e", "JAVA_TOOL_OPTIONS"])

    # The containers currently need to run privileged to allow it to read from e.g.
    # /home on SELinux secured systems such as Fedora. We might want to use udica
    # instead in the future.
    docker_run_options.extend(["--privileged=true"])

    docker_run_options.extend([docker_image])
    docker_run_options.extend(argv)

    docker_run_command = ["docker", "run"] + docker_run_options
    c = subprocess.run(docker_run_command)
    sys.exit(c.returncode)


if __name__ == "__main__":
    main()
