def main(ctx):
  if ctx.build.event == "tag":
    name = "release"
    dry_run = False
    auto_tag = True
  elif ctx.build.branch == "master":
    name = "master"
    dry_run = True
    auto_tag = False
  else:
    return

  return {
    "kind": "pipeline",
    "name": name,
    "steps": [
      {
        "name":  "prepare data",
        "image": "alpine",
        "commands": [
          "apk update && apk add bash curl",
          "FORCE_DOWNLOAD=y ./build-tmp-XXX"
        ]
      },
      {
        "name": "build core",
        "image": "plugins/docker",
        "settings": {
          "dry_run": dry_run,
          "auto_tag": auto_tag,
          "username": { "from_secret": "docker_username" },
          "password": { "from_secret": "docker_password" },
          "repo": "mikegerber/my_ocrd_workflow-core",
          "dockerfile": "Dockerfile-core",
        }
      }
    ]
  }
