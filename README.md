# VICE-RStudio

The [Rocker Project](https://www.rocker-project.org) provides Docker images for
running statistical software based on [R](https://www.r-project.org/) within
standardized container environments, including containers with the popular IDE
for R, [RStudio](https://rstudio.com/products/rstudio/#rstudio-server).
[CyVerse](https://www.cyverse.org/) provides tools for large-scale data analysis
to the academic life science community, including
[VICE](https://learning.cyverse.org/projects/vice/en/latest/), which runs
interactive containerized applications. The Rocker RStudio images need some
minor additioms before they will work in VICE, so the VICE-RStudio images extend
the Rocker images with these changes.

## Variants

The [upstream Rocker images](https://hub.docker.com/r/rocker/r-ver) come from a
series intended to produce reproducible data analysis results. Different
variants in this series have different amounts of system software and R packages
included, and the variants included here range from a basic RStudio installation
(here `base`, `rstudio` upstream), to a variant with a very popular set of R
packages and a development environment pre-installed (`tidyverse`), to a variant
with a full-scale publication package included (`verse`), and finally to a
variant that includes a selected subset of the R-based software for geospatial
analysis (`geospatial`).

## Tags

Rocker uses tags differently from the most common convention for tagged Docker
images. It's usual for tags to refer to a snapshot of the development of
software at some particular time, immutably freezing the state it was in then
(often corresponding to a particular tag or commit in a Git repository, and
follwing the the conventions of semantic versioning). Tags in the versioned
series of Rocker images refer instead to the particular release of R software
they use. R is indeed frozen to a very specific version, but other aspects of
the container (such as OS security patches) can change through time. The intent
is to hold the statistical software environment as constant as possible to
ensure reproducible results, but allow the supporting software to change in
response to current circumstances. Rocker's approach continues to be relevant to
the VICE-RStudio images. If there s some change to the VICE environmant (such as
an update to the iRODS software) it's important that all tagged images (not just
the most recent) adapt to the change: someone may need to re-run an analysis
that's defined using an older version of R. Because these tags refer to mutable
images, there may be problems with image caching under some circumstances: for
example a CI/CD system may not realize that the cached copy of the image it is
holding isn't the most recent available, so in some circumstances it might be
necessary to use explicit sha256 hashes rather than tags to refer to these
images.

## Updating

Because all variants and tags may need re-built for an update, the Git
repository for VICE-RStudio steals an idea from the repositories behind some of
the official Docker images on Docker Hub, such as the
[PHP](https://github.com/docker-library/php) repository. It is structured as a
two-level branching hierarchy (here with the tags nested withon the variants,
the reverse of the PHP example); a top-level script, `update.sh` re-generates
the Dockerfiles that define the image builds for each combination of a variant
and a tag, analogous to the
[update.sh](https://github.com/docker-library/php/blob/master/update.sh) in the
official Docker PHP example. So although for convenience everything in the
repository is under version control, in practice many of the contents are
automatically generated artefacts. The individual tag subdirectories are
completely ephemeral, destroyed and re-created on each update. The variant
subdirectories and top-level directory survive, and can hold various
customizations, but the updating script re-generates the variant README.md files
from a template. The script itself uses only a minimal set of POSIX-compliant
features, and can run in a tiny environment, such as a Busybox container (it
does not require anything included in the VICE-Rstudio images).