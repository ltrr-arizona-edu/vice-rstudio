#
# The `update.sh` script has generated this VICE-RStudio Dockerfile.
# Please do not try to modify it directly.
#
FROM rocker/geospatial:latest

ENV GOMPLATE_VERSION="v2.5.0" \
    IRODS_ICOMMANDS="irods-icommands-4.1.10-ubuntu14-x86_64" \
    LIB_SSL_LEGACY="libssl1.0.0_1.0.1t-1+deb8u8_amd64" \
    PASSWORD="rstudio1" \
    REDIRECT_URL="http://localhost/"

RUN set -e \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    apt-transport-https \
    curl \
    gnupg2 \
    libfuse2 \
    lsb-compat \
    nginx \
    python-requests \
    supervisor \
  && wget -q http://ftp.se.debian.org/debian/pool/main/o/openssl/${LIB_SSL_LEGACY}.deb \
  && dpkg -i ${LIB_SSL_LEGACY}.deb \
  && rm ${LIB_SSL_LEGACY}.deb \
  && wget -q https://files.renci.org/pub/irods/releases/4.1.10/ubuntu14/${IRODS_ICOMMANDS}.deb \
  && dpkg -i ${IRODS_ICOMMANDS}.deb \
  && rm ${IRODS_ICOMMANDS}.deb \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64 -O /usr/local/bin/gomplate \
  && chmod 755 /usr/local/bin/gomplate \
  && echo '#!/bin/sh \
          \ngomplate -f /nginx.conf.tmpl -o /etc/nginx/nginx.conf \
          \nsupervisord -c /etc/supervisor/supervisord.conf -n' \
          > /usr/local/bin/run.sh \
  && chmod 755 /usr/local/bin/run.sh \
  && echo '# Server Configuration File \
          \n \
          \nwww-address=127.0.0.1 \
          \nrsession-which-r=/usr/local/bin/R' \
          > /etc/rstudio/rserver.conf \
  && echo '[program:nginx] \
          \ncommand=nginx' \
          > /etc/supervisor/conf.d/nginx.conf \
  && echo '[program:rstudio] \
          \ncommand=/usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/supervisor/conf.d/rstudio.conf \
  && /bin/bash -c /etc/cont-init.d/userconf

COPY nginx.conf.tmpl /nginx.conf.tmpl

ENTRYPOINT ["/usr/local/bin/run.sh"]
