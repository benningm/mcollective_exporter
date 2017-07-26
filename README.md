# mcollective_exporter

A prometheus metric exporter to scrape targets with mcollective.

## Overview

![mcollective architecture overview](https://user-images.githubusercontent.com/5088512/28607239-4095f080-71db-11e7-8453-b4c0a301a2f4.png)

### The agent

The prometheus agent plugin will run within the mcollectived
running on the managed nodes.
It allows the exporter to discover nodes with their targets
and to retrieve the targets.

### mcollective_exporter

The mcollective_exporter is a simple web server. It provides a
list of discovered agents in prometheus file_sd_config format
and a path to scrape targets.

## Configuration

### Agent configuration

On the agent the prometheus plugin must be deployed by installing
the `prometheus.rb` and `prometheus.ddl` into on of the agents
`libdir` locations.

The agent reads its targets from `/etc/prometheus-targets.yml`:

```
---
node: http://localhost:9100/metrics
```

### Mcollective Exporter

The mcollective_exporter could be started as a docker container.

A mcollective `client.cfg` must be provided:

```
$ docker run -p 9100:80 -v '/mypath/myclient.cfg:/root/.mcollective' benningm/mcollective_exporter
```

### Prometheus

You can scrape the mcollective_exporter with the following prometheus
configuration:

```
scrape_configs:
  - job_name: 'mcollective'
    scrape_interval: 5s

    file_sd_configs:
      - files:
        - /etc/prometheus/targets.json
        refresh_interval: 30s

    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
      - source_labels: [__address__]
        target_label: __param_host
      - source_labels: [target]
        target_label: __param_target
      - target_label: __address__
        replacement: localhost:9100
```

The targets.json file could be retrieved from the mcollective_exporter
discovery location:

```
$ wget -O /etc/prometheus/targets.json http://localhost:9100/discover
```

You may want to do that in a cron job.

