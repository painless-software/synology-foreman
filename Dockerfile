FROM quay.io/foreman/foreman:2.3-stable

COPY --chown=foreman:root db/seeds.d/9??-* db/seeds.d/
