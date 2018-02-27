# micro-golang
##### A super lightweight microservice container for golang applications, including ci testing context and toolchain image
Version 2

[ ![Codeship Status for twhiston/micro-golang](https://app.codeship.com/projects/cb4b5360-2c28-0135-d4a4-7229e0f954fc/status?branch=master)](https://app.codeship.com/projects/224201)

## Contexts

All containers are based on Alpine 3.7 and Golang 1.9.

All contexts fully support application installation either via `go get` or `dep`.
Install type detection is done on the presence of a `Gopkg.lock` file in your app root.

All containers copy your application source to `/go/src/app` and install it to `/usr/local/bin/app`.
The default container entrypoint will be your application.

### Prod

The `prod` image is a basic ONBUILD production image that can be used for golang containers,
it installs the application and toolchain in a single run command so that they can be removed
cleanly and the image size minimized.

To make use of this image you must derive a Dockerfile from it.
The minimal implementation of a working Dockerfile would be:
```
FROM tomwhiston/micro-golang:prod
```

The image contains a runtime user which could also be told to run the container in your Dockerfile.
You should set this if you plan to use this image on Openshift or another root user restricting platform
```
FROM tomwhiston/micro-golang:prod
USER 1001
```

The image does NOT expose any ports by default, you must do this in your application Dockerfile

Containers built with this image will be alpine-image-size + application-binary-size.

### Prodv3

The `prodv3` context is based around an ONBUILD multi-stage Dockerfile process, and uses 2 images.
The builder image contains the Golang toolchain (and dep) and builds your application, it is then injected into the runtime container.
The builder image is ~566MB in size, but because the toolchain is not required to be installed at build time, as long as you can cache the
builder image on your ci/cd platform the overall build speed will be greatly reduced.

The minimal implementation of a working Dockerfile would be:
```
FROM tomwhiston/micro-golang:prodv3-builder AS builder
FROM tomwhiston/micro-golang:prodv3-runtime
```
This slightly unusual format is required for the ONBUILD instructions in the builder image to be triggered properly.

Unlike the `prod` context the runtime image will run as USER 1001 as default.

Containers built with this image will be alpine-image-size + application-binary-size.

### Test

The `test` context is an ONBUILD test container for golang projects which additionally installs the following golang tools

- godacov
- goverage
- cover
- gometalinter

to help with building and testing golang applications in a ci environment.

The minimal implementation of a working Dockerfile would be:
```
FROM tomwhiston/micro-golang:test
```

Unlike the other images this containers CMD is a testing script which exposes additional hook scripts which can be used to control the testing process.

These hooks are expected to be named bash scripts, and their default location is a `.mgl` folder in your application root. This location can be changed by setting the containers environmental variables

#### Environmental Variables

The following environmental variables are set in the container and used to determine the location of scripts to run during the test process.

- MGL_APP_ROOT="/go/src/app"
- MGL_INSTALL=true
- MGL_TEST=true
- MGL_LINT=true
- MGL_CONFIG_PATH="/go/src/app/.mgl"
- MGL_LINT_CONFIG="gometalinter.json"
- MGL_SCRIPT_PRE_INSTALL="pre-install"
- MGL_SCRIPT_POST_DEPS="post-deps" * only if install uses dep
- MGL_SCRIPT_POST_INSTALL="post-run" * only in prod container
- MGL_SCRIPT_PRE_RUN="pre-run" * only in test container
- MGL_SCRIPT_POST_RUN="post-run" * only in test container
- MGL_SCRIPT_EXIT="exit"


`MGL_SCRIPT_*` variables are expected to point to scripts which can be sourced by `go/scripts/install.sh` and `go/scripts/test.sh`

#### Test Flow

- If existent run `MGL_SCRIPT_PRE_INSTALL`
- If `$MGL_INSTALL == 'true'` install the application dependencies using either `go get` or `dep ensure`
- If existent run `MGL_SCRIPT_PRE_RUN`
- If `$MGL_TEST == 'true'` run the tests and generate coverage
- If `$MGL_LINT == 'true'` then run gometalinter with optional config file `MGL_LINT_CONFIG` (note, if no config file is set micro-golang will always set the --vendor option)
- If existent run `MGL_SCRIPT_POST_RUN`

If at any time the above sequence fails and exit is called it will be trapped and `MGL_SCRIPT_EXIT` will be called.
Additionally as part of the exit script if `CODACY_TOKEN` is set any coverage generated will be shipped to [Codacy](https://www.codacy.com)

Tip: As you need to supply your commit id to codacy and `MGL_SCRIPT_EXIT` is called before the coverage is posted you can easily make the exit script set the variable
```
export COMMIT_ID=${CI_COMMIT_ID} #Your ci's commit id variable name
```

The container additionally adds the script `/go/scripts/hold.sh` which you can use to hold a container open for debug purposes.

This container image will be ~835MB. As most of this comes from the parent the build process will be of good speed.

## Development

The following dependencies are needed for developing micro-golang

- go toolchain
- docker
- task
- hadolint
- shellcheck
- goss

Check Taskfile.yml for the definition of all tasks for building, linting etc.... the project.

### CI

The ci folder contains an image for testing micro-golang in a ci environment, this installs docker, goss and task
and is used to build the containers on the ci (does not currently lint or shellcheck due to package unavailability)

Your ci will need to make the docker socket (or a dind service) available for the image for the build process to work correctly.

## v1 images

v1 images will remain on docker hub with the v1 prefix, but will no longer be supported or updated
(this will not be done until v2 is released)
