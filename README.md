FSL community BSP docker base image
=====================================

This image will install an operating system ready to build the FSL community BSP.

Build:

```
export RELEASE=warrior
docker build -t docker-fsl:$RELEASE --build-arg FSL_BRANCH=$RELEASE --no-cache .
```

Use:

```
export HOST_BUILD_DIR=${HOME}/workspace
docker run -it --rm --volume ${HOST_BUILD_DIR}:/usr/local/fsl/build <container-id>
```
