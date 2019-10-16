#
# The `update.sh` script has generated this VICE-RStudio Dockerfile.
# Please do not try to modify it directly.
#
FROM rocker/verse:3.6.0

ENV IRODS_ICOMMANDS="irods-icommands-4.1.10-ubuntu14-x86_64" \
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
    nginx \
    python-requests \
  && wget -q http://ftp.se.debian.org/debian/pool/main/o/openssl/${LIB_SSL_LEGACY}.deb \
  && dpkg -i ${LIB_SSL_LEGACY}.deb \
  && rm ${LIB_SSL_LEGACY}.deb \
  && wget -q https://files.renci.org/pub/irods/releases/4.1.10/ubuntu14/${IRODS_ICOMMANDS}.deb \
  && dpkg -i ${IRODS_ICOMMANDS}.deb \
  && rm ${IRODS_ICOMMANDS}.deb \
  && rm -rf /var/lib/apt/lists/* \
  && echo 'www-address=127.0.0.1' >> /etc/rstudio/rserver.conf \
  && echo '#!/usr/bin/with-contenv sh \
          \nsed -e "s%{{REDIRECT_URL}}%${REDIRECT_URL}%" /nginx.conf.tmpl > /etc/nginx/nginx.conf' \
          > /etc/cont-init.d/setupreverseproxy \
  && mkdir -p /etc/services.d/nginx \
  && echo '#!/usr/bin/with-contenv sh \
          \nnginx' \
          > /etc/services.d/nginx/run

COPY nginx.conf.tmpl /nginx.conf.tmpl

CMD ["/init"]
