# BUNDOORA

Devcontainer for ML project.


# Build the image

To build the image for the default platform (linux/amd64)

```bash
make build
```

To build the image for multiple platforms and load it locally

```bash
make build-multi
```

To build the image for multiple platforms and push it to a registry

```bash
make push-multi IMAGE_NAME=yourusername/test
```

To create and use a new builder instance

```bash
make create-builder
```

