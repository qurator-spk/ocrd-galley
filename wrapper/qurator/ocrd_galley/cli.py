import os
import subprocess
import sys


DOCKER_IMAGE_PREFIX = os.environ.get("DOCKER_IMAGE_PREFIX", "my_ocrd_workflow")
DOCKER_IMAGE_TAG = os.environ.get("DOCKER_IMAGE_TAG", "latest")
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")


def main():
    argv = sys.argv.copy()
    argv[0] = os.path.basename(argv[0])

    if argv[0] == "ocrd":
        docker_image = "%s-core:%s" % (DOCKER_IMAGE_PREFIX, DOCKER_IMAGE_TAG)

    docker_run(argv, docker_image)


def docker_run(argv, docker_image):
    docker_run_options = []
    docker_run_options.extend(["--rm", "-t"])
    docker_run_options.extend(["--mount", "type=bind,src=%s,target=/data" % os.getcwd()])
    docker_run_options.extend(["--user", "%s:%s" % (os.getuid(), os.getgid())])
    docker_run_options.extend(["-e", "LOG_LEVEL=%s" % LOG_LEVEL])

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
