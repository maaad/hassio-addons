## Victoria Metrics as hassio-addon
# Configuration example
configuration.yaml
```yaml
influxdb:
 host: <IP>
 port: 8428
 include:
   domains:
     - sensor
```
/usr/share/hassio/homeassistant/victoria-metrics/prometheus.yml
```yaml
global:
  scrape_interval: 10s
scrape_configs:
  - job_name: 'victoriametrics'
    static_configs:
      - targets: ['localhost:8428']
```