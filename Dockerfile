FROM python:3.6-alpine

ARG CURATOR_VERSION

RUN pip install  elasticsearch-curator==${CURATOR_VERSION} &&\
    rm -rf /var/cache/apk/*

COPY ./config/ /config

RUN /usr/bin/crontab /config/crontab.txt

CMD ["/usr/sbin/crond","-f"]
