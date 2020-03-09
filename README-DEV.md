Releasing
---------
* `git tag -m 'v<version>' 'v<version>'`
* `for r in origin github; do git push -d $r stable; done`
* `git tag -fm 'stable' 'stable'`
* `for r in origin github; do git push --tags $r; done`
  * This triggers Travis builds
