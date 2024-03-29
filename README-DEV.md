How to add a processor
----------------------
* Add model download to `build` (if necessary)
* Add a Dockerfile
* Add commands to `wrapper/qurator/ocrd_galley/cli.py`

Releasing
---------
* `git tag -m 'v<version>' 'v<version>'`
* `for r in origin github github-qurator-spk; do git push -d $r stable; done`
* `git tag -fm 'stable' 'stable'`
* `for r in origin github github-qurator-spk; do git push --tags $r master; done`
  * This - the tags - triggers Travis builds for the mikegerber repo,
    including building the Docker images and pushing them to Docker Hub.
  * Make sure that qurator-spk gets tags pushed (for consistency).
* Create release on GitHub

Inclusion policy
----------------
1. Only use PyPI version where possible.
2. If that is not possible (= available) use a versioned release from GitHub
3. Otherwise, use a GitHub commit

If, for some reason, we must deviate from this, to e.g. hotfix something, an
issue should be open that reminds us to go back to a versioned release again.

Other than relying on "proper releases", this also has a second purpose: Review
releases of qurator-spk releases.


Test builds
-----------
```
GIT_COMMIT=test ./build Dockerfile-core Dockerfile-ocrd_tesserocr
DOCKER_IMAGE_TAG=test ./test-ocrd_tesserocr.sh
```

To test the GitHub Action builds:

```
# by branch
# Note that these only get tagged if *all* the builds succeeded and ran their
# tests successfully
export DOCKER_IMAGE_TAG=master

# by git commit id
# these work even if other processors did not succesfully build (or ran their
# tests successfully)
export DOCKER_IMAGE_TAG=sha-af6da489e24c9ba7828114b546610b0d70116ba4
```
