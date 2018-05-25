FROM python:3.6-alpine

RUN pip install  elasticsearch-curator==5.5.4 &&\
    rm -rf /var/cache/apk/*

COPY ./config/ /config

RUN /usr/bin/crontab /config/crontab.txt

CMD ["/usr/sbin/crond","-f"]
