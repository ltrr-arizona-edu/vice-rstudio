#!/bin/sh
#------------------------------------------------------------------------------
#
# update.sh: automatically regenerate all the vice-rstudio Dockerfiles.
#
# Inspired by the similarly named script for several Docker Official Images.
#
# Returns:
#   0 on success, 1 on any error.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Optional environment variables with simple defaults.

# Organization or user on Docker Hub.
: "${CYVERSEVICE_DOCKERHUBORG:=cyversevice}"

# Pattern matching tag subdirectories to purge on each update.
: "${CYVERSEVICE_EPHEMERA:=3.* devel latest}"

# List of individually tagged versions to support.
: "${CYVERSEVICE_TAGLIST:=3.4.2 3.5.0 3.5.1 3.5.2 3.5.3 3.6.0 3.6.1 devel latest}"

# List of variant names.
: "${CYVERSEVICE_VARIANTS:=base geospatial tidyverse verse}"

#------------------------------------------------------------------------------
# Command for sed to insert a markdown formatted list from the tag versions.

sedsubsttaglist=$( \
  printf 's/{{taglist}}/'; \
  for t in $CYVERSEVICE_TAGLIST ; do \
    printf '%s %s\\\n' '-' "$t"; \
  done; \
  printf '/' \
)

#------------------------------------------------------------------------------
# Utility function definitions.

errorexit () {
  echo "** $1." >&2
  exit 1
}

# Show progress on STDERR, unless explicitly quiet.
if [ -z "$CYVERSEVICE_QUIET" ]; then
  logmessage () {
    echo "$1..." >&2
  }
  normalexit () {
    echo "$1." >&2
    exit 0
  }
else
  logmessage () {
    return
  }
  normalexit () {
    exit 0
  }
fi

#------------------------------------------------------------------------------
# Build environment and README update functions.

setupbuild () {
  typetitle=$1
  variantname=$2
  tagname=$3
  base=$4
  builddir="${variantname}/${tagname}"
  readme="${builddir}/README.md"
  echo "# v${tagname}" > "$readme" \
    || errorexit "Can't create the minimal text file ${readme}"
  sed -e "s%{{base}}%${base}:${tagname}%g" \
    -e "/{{common_os_packages}}/r common_os_packages_${typetitle}" \
    -e '/{{common_os_packages}}/d' \
    Dockerfile.template > "${builddir}/Dockerfile" \
    || errorexit "Failed to generate the Dockerfile in the ${builddir} subdirectory"
  cp nginx.conf.tmpl "$builddir" \
    || errorexit "Failed to copy the nginx configuration template to the ${builddir} subdirectory"
}

updatereadme () {
  variantname=$1
  base=$2
  varianttitle=$3
  sed -e "s/{{variant}}/${variantname}/g" \
    -e "s/{{varianttitle}}/${varianttitle}/g" \
    -e "s%{{baseimage}}%${base}%g" \
    -e "s/{{dockerhuborg}}/${CYVERSEVICE_DOCKERHUBORG}/g" \
    -e "${sedsubsttaglist}" \
    README.template > "${variantname}/README.md" \
    || errorexit "Failed to generate the README file in the ${variantname} subdirectory"
}

#------------------------------------------------------------------------------
# Update all variants and regenerate the tag subdirectories.

for variant in $CYVERSEVICE_VARIANTS ; do
  [ -d "$variant" ] \
    || errorexit "Could not find the sub-directory for the ${variant} image"
  if [ "$variant" = 'base' ] ; then
    upstream='rocker/rstudio'
    upstreamtitle=''
  else
    upstream="rocker/${variant}"
    upstreamtitle=" with \`${variant}\` dependencies"
  fi
  image="vice-rstudio-${variant}"
  logmessage "${image} (from ${upstream})"
  ( cd "$variant" \
      || errorexit "Couldn't change to the ${variant} subdirectory"
    for ephemeral in $CYVERSEVICE_EPHEMERA ; do
      rm -Rf "$ephemeral" \
        || errorexit "Failed to purge ${variant}/${ephemeral}"
    done
  )
  for tag in $CYVERSEVICE_TAGLIST ; do
    logmessage "${image}:${tag}"
    mkdir "${variant}/${tag}" \
      || errorexit "Couldn't make the subdirectory for ${variant}/${tag}"
    case "$tag" in
      ( 3.* | latest ) setupbuild 'normal' "$variant" "$tag" "$upstream" ;;
      ( devel ) setupbuild 'edge' "$variant" "$tag" "$upstream" ;;
      ( * ) errorexit "Unexpected tag ${tag}"
    esac
  done
  updatereadme "$variant" "$upstream" "$upstreamtitle"
done

normalexit "Updated OK"
