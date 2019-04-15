
# Curator in docker

This is dockerized version of elasticsearch curator,tool to manage time-based indices.

the docker image for [curator][] baseon the [python:3.6-alpine][](this image size only 30mb)

docker hub  https://hub.docker.com/r/anjia0532/docker-curator/ 

[![Automated build](https://img.shields.io/docker/automated/anjia0532/docker-curator.svg)](https://hub.docker.com/r/anjia0532/docker-curator/) [![Docker Pulls](https://img.shields.io/docker/pulls/anjia0532/docker-curator.svg)](https://hub.docker.com/v2/repositories/anjia0532/docker-curator/)
# Usage

## docker-compose.yml

```yaml
version: '2'

services:

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:x.y.z
    ports:
    - 9200:9200/tcp
    #environment:
    #    - http.host=0.0.0.0
    #    - transport.host=127.0.0.1
    # Uncomment this section to have elasticsearch data loaded from a volume
    #volumes:
    #    - /data/path/to/host/:/usr/share/elasticsearch/data

  curator:
    image: anjia0532/docker-curator
    environment:
        UNIT_COUNT: 10
        UNIT: days
        ES_HOST: elasticsearch
    depends_on:
      - elasticsearch
    volumes:
        - /config/path/to/host/:/config
```

## action_file.yml(default)

### env default value
- UNIT_COUNT: 1
- UNIT: months
- ES_HOST: 127.0.0.1

```yaml
actions:
  1:
    action: delete_indices
    description: >-
       Delete indices older than ${UNIT_COUNT:1} ${UNIT:months} (based on index name), for logstash-
       prefixed indices. Ignore the error if the filter does not result in an
       actionable list of indices (ignore_empty_list) and exit cleanly.
    options:
      ignore_empty_list: True
      timeout_override:
      continue_if_exception: True
      disable_action: False
    filters:
    - filtertype: pattern
      kind: prefix
      value: logstash-
      exclude:
    - filtertype: age
      source: name
      direction: older
      timestring: '%Y.%m.%d'
      unit: ${UNIT:months}
      unit_count: ${UNIT_COUNT:1}
      exclude:
#  2:
#    action: delete_indices
#    description: >-
#       Delete indices older than ${UNIT_COUNT:1} ${UNIT:months} (based on index name), for filebeat-
#       prefixed indices. Ignore the error if the filter does not result in an
#       actionable list of indices (ignore_empty_list) and exit cleanly.
#    options:
#      ignore_empty_list: True
#      timeout_override:
#      continue_if_exception: True
#      disable_action: False
#    filters:
#    - filtertype: pattern
#      kind: prefix
#      value: filebeat-
#      exclude:
#    - filtertype: age
#      source: name
#      direction: older
#      timestring: '%Y.%m.%d'
#      unit: ${UNIT:months}
#      unit_count: ${UNIT_COUNT:1}
#      exclude:
#  3:
#    action: delete_indices
#    description: >-
#       Delete indices older than ${UNIT_COUNT:1} ${UNIT:months} (based on index name), for heartbeat-
#       prefixed indices. Ignore the error if the filter does not result in an
#       actionable list of indices (ignore_empty_list) and exit cleanly.
#    options:
#      ignore_empty_list: True
#      timeout_override:
#      continue_if_exception: True
#      disable_action: False
#    filters:
#    - filtertype: pattern
#      kind: prefix
#      value: heartbeat-
#      exclude:
#    - filtertype: age
#      source: name
#      direction: older
#      timestring: '%Y.%m.%d'
#      unit: ${UNIT:months}
#      unit_count: ${UNIT_COUNT:1}
#      exclude:
#  4:
#    action: delete_indices
#    description: >-
#       Delete indices older than ${UNIT_COUNT:1} ${UNIT:months} (based on index name), for heartbeat-
#       prefixed indices. Ignore the error if the filter does not result in an
#       actionable list of indices (ignore_empty_list) and exit cleanly.
#    options:
#      ignore_empty_list: True
#      timeout_override:
#      continue_if_exception: True
#      disable_action: False
#    filters:
#    - filtertype: pattern
#      kind: prefix
#      value: zipkin-
#      exclude:
#    - filtertype: age
#      source: name
#      direction: older
#      timestring: '%Y.%m.%d'
#      unit: ${UNIT:months}
#      unit_count: ${UNIT_COUNT:1}
#      exclude:
```

## config_file.yml
### env default value
- USE_SSL: False
- HTTP_AUTH: ''
- TIMEOUT: 120
- MASTER_ONLY: True

```
---
# Remember, leave a key empty if there is no value.  None will be a string,
# not a Python "NoneType"
client:
  hosts:
    - ${ES_HOST:127.0.0.1}
  port: 9200
  url_prefix:
  use_ssl: ${USE_SSL:False}
  certificate:
  client_cert:
  client_key:
  ssl_no_validate: False
  http_auth: ${HTTP_AUTH:''}
  timeout: ${TIMEOUT:120}
  master_only: ${MASTER_ONLY:True}
logging:
  loglevel: INFO
  logfile:
  logformat: default
  #blacklist: ['elasticsearch', 'urllib3']
```

## cron job

every day at 0:00 am exec

```bash
0 0 * * * curator --config /config/config_file.yml /config/action_file.yml
```

# Curator's doc

Full reference is available at: [https://www.elastic.co/guide/en/elasticsearch/client/curator/current/index.html][curator]

- [Configuration][]
    + [Environment Variables][linkEnvironmentVariables]
    + [Action File][linkActionFile]
    + [Configuration File][linkConfigurationFile]
- [Actions][]
    + ...
    + [Delete Indices][linkDeleteIndices]
    + ...
- ...
- Examples
    + [alias][]
    + [allocation][]
    + [close][]
    + [cluster_routing][]
    + [create_index][]
    + [delete_indices][]
    + [delete_snapshots][]
    + [forcemerge][]
    + [index_settings][]
    + [open][]
    + [reindex][]
    + [replicas][]
    + [restore][]
    + [rollover][]
    + [snapshot][]
- ...

[python:3.6-alpine]: https://hub.docker.com/r/library/python/tags/3.6-alpine/
[curator]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/index.html
[Configuration]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configuration.html
[linkEnvironmentVariables]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/envvars.html
[linkActionFile]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/actionfile.html
[linkConfigurationFile]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/configfile.html
[Actions]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/actions.html
[linkDeleteIndices]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/delete_indices.html
[alias]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_alias.html
[allocation]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_allocation.html
[close]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_close.html
[cluster_routing]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_cluster_routing.html
[create_index]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_create_index.html
[delete_indices]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_delete_indices.html
[delete_snapshots]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_delete_snapshots.html
[forcemerge]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_forcemerge.html
[index_settings]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_index_settings.html
[open]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_open.html
[reindex]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_reindex.html
[replicas]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_replicas.html
[restore]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_restore.html
[rollover]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_rollover.html
[snapshot]: https://www.elastic.co/guide/en/elasticsearch/client/curator/current/ex_snapshot.html
