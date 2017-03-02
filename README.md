# docker-builder
Toolset to build docker containers

# Building Containers

Use `build.sh` to build your new container:
```console
$ ./build.sh ansible
```

docker builder's `build.sh` is configured with environment variables, and is
primarily intended for use inside Jenkins builds. The following variables
control its behavior:

- `DOCKER_LATEST=true` - Adds a `:latest` tag for the container
- `DOCKER_PUSH=true` - Push the container to the repository after building
- `DOCKER_FORCE=true` - Build the container even if it already exists

Take care invoking with `DOCKER_LATEST=true` and `DOCKER_PUSH=true`, as it
will overwrite the 'latest' tag in the registry.

### Names and Versions

Shipyard's `build.sh` automatically names and tags instances based on the
following:

- `name:<checksum>` - git short commit hash for the shipyard repo
- `name:<version>` - if specified in [Metadata](#shipyard-metadata)
- `name:latest` - if `DOCKER_LATEST=true`

# Dockerfiles

To start a new project, create a Dockerfile under a new directory. We'll use
the `ansible` Dockerfile as an example.

```console
$ mkdir -p ansible/
$ cd ansible
$ vim Dockerfile
```

## Docker-Builder Metadata

docker-builder's `build.sh` looks for configuration metadata comments inside the
target Dockerfile:

- `# NAME` The first part of the tag
- `# VERSION` The last part of the tag

Given the following header, `build.sh` would create a container tagged
`dockerhub/rickrussell/ansible:2.2.0`:

```dockerfile
# NAME dockerhub/rickrussell/ansible
# VERSION 2.2.0
```
