# vice-rstudio-tidyverse
RStudio image with `tidyverse` dependencies, based on the
[Rocker RStudio Docker image](https://hub.docker.com/r/rocker/tidyverse),
for CyVerse VICE. VICE requires additional configuration files (e.g. `nginx`) to
be compatible with our Condor and Kubernetes orchestration.

# Instructions

## Run this Docker locally or on a Virtual Machine

To run these containers, you must first pull them from DockerHub

```
docker pull cyversevice/vice-rstudio-tidyverse:latest
```

```
docker run -it --rm -v /$HOME:/app --workdir /app -p 8787:80 -e REDIRECT_URL=http://localhost:8787 cyversevice/vice-rstudio-tidyverse:latest
```

The default username is `rstudio` and password is `rstudio1`. To reset the
password, add the flag `-e PASSWORD=<yourpassword>` in the `docker run`
statement.

## Build your own Docker container and deploy on CyVerse VICE

This container is intended to run on the CyVerse data science workbench, called
[VICE](https://cyverse-visual-interactive-computing-environment.readthedocs-hosted.com/en/latest/index.html).

Unless you plan on making changes to this container, you should just use the
existing launch button above.

## Supported tags

In general, avoid using the `latest` tag to reference a Docker image: the image
it refers to will change over time, but if you use an explicitly numbered tag
such as `3.6.1` you will have a better chance of repeating results in a
reproducible environment. The available tags are based on those the upstream
Rocker project uses, currently
- 3.4.2
- 3.5.0
- 3.5.1
- 3.5.2
- 3.5.3
- 3.6.0
- 3.6.1
- devel
- latest

Use the `devel` tag with caution: it refers to the latest development version,
so might change even more often than `latest` and is not even guaranteed to work
at all.

###### Developer notes

To build your own container with a Dockerfile and additional dependencies, pull
the pre-built image from DockerHub:

```
FROM cyversevice/vice-rstudio-tidyverse:latest
```

Follow the instructions in the
[VICE manual for integrating your own tools and apps](https://cyverse-visual-interactive-computing-environment.readthedocs-hosted.com/en/latest/developer_guide/building.html).
