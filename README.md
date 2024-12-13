# BUNDOORA

Devcontainer for ML project. More about how to use it see [document](.devcontainer/README.md)


# The environment under maintain

|Python|Pytorch|OS|CUDA|
|---|---|---|---|
|3.10|2.5.1|AWS Ubuntu 22.04|12.1|


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

# Research Projects using this repo

* [When Simpler Is Better: Traditional Models Outperform LLMs in ICU Mortality Prediction](https://github.com/Aisuko/multimodal-mimic)


# Citation

```bibtex
@software{Li_Bundoora_2024,
author = {Li, Bowen},
doi = {<>},
month = dec,
title = {{Bundoora}},
url = {https://github.com/SkywardAI/bundoora},
version = {1.0.0},
year = {2024}
}
```