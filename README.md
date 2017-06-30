# Microservice container for golang
[ ![Codeship Status for twhiston/micro-golang](https://app.codeship.com/projects/cb4b5360-2c28-0135-d4a4-7229e0f954fc/status?branch=master)](https://app.codeship.com/projects/224201)

Super light alpine container for golang microservices.
Includes testing context to use in ci builds

To minimize final image size, and to work around image caching this docker image will install docker, get dependencies and build your app, and uninstall go ONBUILD
This allows us to keep the image extremely light. A small golang app will be ~10MB, using the golang alpine image it will be ~200MB

The dockerfile in the root of you project can be used to build and deploy applications on openshift, sloppy.io etc....

## Contexts

### Prod

Production environment which installs go, installs the app and removes go at ONBUILD time.
This results in the smallest possible images.
Images are usually around the size of:

- go binary size + ~4MB
- (comparison) golang alpine ~230MB


To use the container to compile and run your app add a dockerfile to your project root

_Dockerfile_
```
FROM tomwhiston/micro-golang:prod
```

If your app exposes no ports, and needs nothing else this is all you need to do.
Commonly you might want to expose a port
```
EXPOSE 8000
```

Because it copies in your app at ONBUILD time you need to create a descendant docker image from it, thus running `docker run pwcsexperiencecenter/micro-golang:testing` will just result in an error that no source exists

If required you could also create a docker compose as follows

_docker-compose.yml_
```
version: "2"

services:
  my_app:
    build: .
    image: myorg/mypackage:latest
```

If using docker-compose you will want to rebuild the container each time you run it to compile the new source code
`docker-compose up --build`

### Testing

Installs cover and gometalinter. Build process leaves full go and gcc installed as it is needed for coverage.
This means that image sizes will be significantly larger than production versions.
You can easily orchestrate this using a ci such as codeship or jenkins
(for codeship the codeships-services.yml could be identical to the docker-compose.yml below, though you may wish to add exposed ports and cache the image etc....)

To run the testing version locally is almost identical to the prod version

_Dockerfile-test_
```
FROM tomwhiston/micro-golang:test

# Customize as needed, normally can be exactly the same as your prod file
```

_docker-compose.yml_
```
version: "2"

services:
  my_app:
    # Additional build context options compared to prod
    build:
      context: .
      dockerfile: Dockerfile-test
    image: myorg/mypackage:latest
```

### Alternative testing instructions

If you wish to hold a test container open while you develop and incrementally run tests against your code you could
also use this container as follows

_Dockerfile-test_
```
FROM tomwhiston/micro-golang:test

# Customize as needed, normally can be exactly the same as your prod file
```

_docker-compose.yml_
```
version: "2"

services:
  my_app:
    # Additional build context options compared to prod
    build:
      context: .
      dockerfile: Dockerfile-test
    image: myorg/mypackage:latest
    volumes:
        - ./:/go/src/app
    entrypoint: /go/scripts/hold.sh
```

`docker-compose up` starts the container with a script that will simply hold it open for you
`docker exec -i -t my_container_name_or_id /bin/bash` will put you into the interactive shell in the project code directory.

Because we have bound the current directory to the volume changes will be reflected in the container.
Thus you can simply run `/go/scripts/test.sh` in the container or `docker exec my_container_name_or_id /go/scripts/test.sh` from outside of the container to trigger the tests.
(snippet expansion programs can be useful to help wrangle docker exec commands more effectively)
This allows you to run tests within a near deployment environment without the overhead of building the image every time

### Changing the test script

Either make your own version of the container or override `/go/scripts` by mounting a volume over the top of it with a file called `test.sh` in it

## Limitations

If you need extra libraries to be installed before `go get` and `go build` are called then you will need to create your own image using this Dockerfile as a guide.