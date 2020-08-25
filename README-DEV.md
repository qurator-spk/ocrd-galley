Releasing
---------
* `git tag -m 'v<version>' 'v<version>'`
* `for r in origin github github-qurator-spk; do git push -d $r stable; done`
* `git tag -fm 'stable' 'stable'`
* `for r in origin github github-qurator-spk; do git push --tags $r; done`
  * This - the tags - triggers Travis builds for the mikegerber repo,
    including building the Docker images and pushing them to Docker Hub.
  * Make sure that qurator-spk gets tags pushed (for consistency).
