# Docker multi-stage build - https://docs.docker.com/develop/develop-images/multistage-build/
# Use an alpine node image to install the plugin
FROM node:lts-alpine as builder

RUN mkdir -p /verdaccio/plugins \
    && cd /verdaccio/plugins \
    && npm install --global-style --no-bin-links --omit=optional verdaccio-auth-memory@latest

FROM verdaccio/verdaccio:5

# copy your modified config.yaml into the image
ADD docker.yaml /verdaccio/conf/config.yaml
# need it for install global plugins
USER root
# install plugins with npm global
RUN npm install --global verdaccio-static-token \
    && npm install --global verdaccio-auth-memory
# back to original user
USER $VERDACCIO_USER_UID