# Define variables for image name and platforms
IMAGE_NAME ?= test
PLATFORMS ?= linux/amd64

# Default target: Build the image for the specified platform(s)
build:
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_NAME) --load .

# Target to build images for multiple platforms
build-multi:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) --load .

# Target to push the multi-platform image to a registry
push-multi:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) --push .

# Target to create and use a new builder instance
create-builder:
	docker buildx create --name mybuilder --use
