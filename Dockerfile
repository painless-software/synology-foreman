ARG FOREMAN_VERSION=2.3-stable

FROM quay.io/foreman/foreman:${FOREMAN_VERSION}

COPY --chown=foreman:root db/seeds.d/9??-* db/seeds.d/
