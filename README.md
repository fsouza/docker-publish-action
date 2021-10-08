# docker-publish-action

This repository contains a composite GitHub action for publishing images to
Docker Hub. It's basically a generalization of a script that I used to
replicate across different repositories.

## How to use it

See real examples from
[docker-ssl-proxy](https://github.com/fsouza/docker-ssl-proxy/blob/main/.github/workflows/docker-publish.yml),
[fake-gcs-server](https://github.com/fsouza/fake-gcs-server/blob/HEAD/.github/workflows/docker-push.yml)
or
[s3-upload-proxy](https://github.com/fsouza/s3-upload-proxy/blob/main/.github/workflows/docker-push.yml).

Or do something like this:

```yaml
on: [push]

jobs:
  publish-to-docker-hub:
    runs-on: ubuntu-latest
    name: Publishes an image to Docker Hub
    steps:
      - uses: actions/checkout@v2

      - id: foo
        uses: fsouza/docker-publish-action@main
        with:
          docker-image: example/image
          docker-username: ${{ secrets.DOCKER_USERNAME }}
          docker-password: ${{ secrets.DOCKER_PASSWORD }}
```

Note: this action requires `os.runner` to be Linux.

## Does it support other registries?

No, but I'm up to adding it, but let's not make this too complicated. It's
shell script after all.
