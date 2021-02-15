def main(ctx):
  tags = [ctx.build.commit]

  if ctx.build.event == "tag":
    name = "release"
  elif ctx.build.branch == "master":
    name = "master"
    tags.append("latest")
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
      # We can't glob and have to add here manually...
      step_for(ctx, "core", tags),
      step_for(ctx, "core-cuda10.0", tags),
      step_for(ctx, "core-cuda10.1", tags),

      step_for(ctx, "dinglehopper", tags),
      step_for(ctx, "ocrd_calamari", tags),
      step_for(ctx, "ocrd_calamari03", tags),
      step_for(ctx, "ocrd_cis", tags),
      step_for(ctx, "ocrd_fileformat", tags),
      step_for(ctx, "ocrd_olena", tags),
      step_for(ctx, "ocrd_segment", tags),
      step_for(ctx, "ocrd_tesserocr", tags),
      step_for(ctx, "sbb_binarization", tags),
      step_for(ctx, "sbb_textline_detector", tags),
    ]
  }

def step_for(ctx, sub_image, tags):
  return {
    "name": "build %s" % sub_image,
    "image": "plugins/docker",
    "settings": {
      "build_args": [
        "DRONE_COMMIT=%s" % ctx.build.commit,
      ],
      "tags": tags,
      "username": { "from_secret": "docker_username" },
      "password": { "from_secret": "docker_password" },
      "repo": "quratorspk/ocrd-galley-%s" % sub_image,
      "dockerfile": "Dockerfile-%s" % sub_image,
    }
  }
