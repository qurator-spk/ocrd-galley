def main(ctx):
  if ctx.build.event == "tag":
    name = "release"
    dry_run = False
  elif ctx.build.branch == "master":
    name = "master"
    dry_run = True
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
      step_for("core", dry_run),
      step_for("ocrd_tesserocr", dry_run),
    ]
  }

def step_for(sub_image, dry_run):
  auto_tag = not dry_run
  return {
    "name": "build %s" % sub_image,
    "image": "plugins/docker",
    "settings": {
      "dry_run": dry_run,
      "auto_tag": auto_tag,
      "purge": False,
      "username": { "from_secret": "docker_username" },
      "password": { "from_secret": "docker_password" },
      "repo": "mikegerber/my_ocrd_workflow-%s" % sub_image,
      "dockerfile": "Dockerfile-%s" % sub_image,
    }
  }
