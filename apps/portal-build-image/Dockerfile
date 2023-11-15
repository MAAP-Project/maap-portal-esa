FROM node:16.15

RUN apt update && \
    apt install python-pip -y && \
    pip install awscli

WORKDIR /app

# https://github.com/cypress-io/cypress/issues/1281
# EACCES: permission denied, mkdir '/root/.cache/Cypress'
ENV CYPRESS_CACHE_FOLDER /app/.cache
