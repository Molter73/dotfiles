all:
	podman build \
		--tag quay.io/mmoltras/devcontainers:devc \
		--build-arg DEFAULT_USER=$(shell id -u) \
		--build-arg DEFAULT_GROUP=$(shell id -g) \
		-f Containerfile \
		$(CURDIR)

.PHONY: all
