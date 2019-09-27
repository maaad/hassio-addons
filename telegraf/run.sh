#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

agent_hostname=$(jq --raw-output ".agent.hostname" $CONFIG_PATH)
agent_interval=$(jq --raw-output ".agent.interval" $CONFIG_PATH)
agent_round_interval=$(jq --raw-output ".agent.round_interval" $CONFIG_PATH)
agent_metric_buffer_limit=$(jq --raw-output ".agent.metric_buffer_limit" $CONFIG_PATH)
agent_flush_buffer_when_full=$(jq --raw-output ".agent.flush_buffer_when_full" $CONFIG_PATH)
agent_collection_jitter=$(jq --raw-output ".agent.collection_jitter" $CONFIG_PATH)
agent_flush_interval=$(jq --raw-output ".agent.flush_interval" $CONFIG_PATH)
agent_flush_jitter=$(jq --raw-output ".agent.flush_jitter" $CONFIG_PATH)
agent_debug=$(jq --raw-output ".agent.debug" $CONFIG_PATH)
agent_quiet=$(jq --raw-output ".agent.quiet" $CONFIG_PATH)

outputs_influxdb_database=$(jq --raw-output ".outputs.influxdb_database" $CONFIG_PATH)
outputs_influxdb_username=$(jq --raw-output ".outputs.influxdb_usernmae" $CONFIG_PATH)
outputs_influxdb_password=$(jq --raw-output ".outputs.influxdb_password" $CONFIG_PATH)
outputs_influxdb_retention_policy=$(jq --raw-output ".outputs.influxdb_retention_policy" $CONFIG_PATH)
outputs_influxdb_precision=$(jq --raw-output ".outputs.influxdb_precision" $CONFIG_PATH)
outputs_influxdb_timeout=$(jq --raw-output ".outputs.influxdb_timeout" $CONFIG_PATH)
outputs_influxdb_urls=$(jq --raw-output ".outputs.influxdb_urls | length" $CONFIG_PATH)
if [ "$outputs_influxdb_urls" -gt "0" ]
then
    outputs_influxdb_url="["
    for (( i=0; i < "$outputs_influxdb_urls"; i++ )); do
        if [ "$i" -ne 0 ]
        then
           outputs_influxdb_url="$outputs_influxdb_url,"
        fi
        temp_url=$(jq --raw-output ".outputs.influxdb_urls[$i]" $CONFIG_PATH)
        outputs_influxdb_url="$outputs_influxdb_url\"$temp_url\""
    done
    outputs_influxdb_url="$outputs_influxdb_url]"
fi

inputs_ping_urls=$(jq --raw-output ".inputs.ping_urls | length" $CONFIG_PATH)
if [ "$inputs_ping_urls" -gt "0" ]
then
    inputs_ping_url="["
    for (( i=0; i < "$inputs_ping_urls"; i++ )); do
        if [ "$i" -ne 0 ]
        then
           inputs_ping_url="$inputs_ping_url,"
        fi
        temp_url=$(jq --raw-output ".inputs.ping_urls[$i]" $CONFIG_PATH)
        inputs_ping_url="$inputs_ping_url\"$temp_url\""
    done
    inputs_ping_url="$inputs_ping_url]"
fi

configuration="
[global_tags]

# Configuration for telegraf agent
[agent]
  interval = \"$agent_interval\"
  round_interval = $agent_round_interval
  metric_buffer_limit = $agent_metric_buffer_limit
  flush_buffer_when_full = $agent_flush_buffer_when_full
  collection_jitter = \"$agent_collection_jitter\"
  flush_interval = \"$agent_flush_interval\"
  flush_jitter = \"$agent_flush_jitter\"
  debug = $agent_debug
  quiet = $agent_quiet
  logfile = \"/var/log/telegraf/telegraf.log\"
  hostname = \"$agent_hostname\"


###############################################################################
#                                  OUTPUTS                                    #
###############################################################################

# Configuration for influxdb server to send metrics to
[[outputs.influxdb]]
  urls = $outputs_influxdb_url # required
  database = \"$outputs_influxdb_database\" # required
  precision = \"$outputs_influxdb_precision\"
  timeout = \"$outputs_influxdb_timeout\"
  username = \"$outputs_influxdb_username\"
  password = \"$outputs_influxdb_password\"
  retention_policy = \"$outputs_influxdb_retention_policy\"


###############################################################################
#                                  INPUTS                                     #
###############################################################################

# Read metrics about cpu usage
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fielddrop = [\"time_*\"]
  collect_cpu_time = true
  report_active = true

# Read metrics about disk usage by mount point
[[inputs.disk]]
  ignore_fs = [\"tmpfs\", \"devtmpfs\"]

# Read metrics about disk IO by device
[[inputs.diskio]]

# Read metrics about memory usage
[[inputs.mem]]

# Read metrics about swap memory usage
[[inputs.swap]]

# Read metrics about system load & uptime
[[inputs.system]]

[[inputs.ping]]
  ## List of urls to ping
  urls = $inputs_ping_url # required
  count = 1
  ping_interval = 1.0

# Get the number of processes and group them by status
[[inputs.processes]]

# Get kernel statistics from /proc/stat
[[inputs.kernel]]

# Get kernel statistics from linux_sysctl_fs
[[inputs.linux_sysctl_fs]]

#[[inputs.docker]]
#  endpoint = \"unix:///var/run/docker.sock\"
#  container_names = []
#  timeout = \"5s\"

# Collect statistics about itself
[[inputs.internal]]
  collect_memstats = true

[[inputs.net]]

[[inputs.netstat]]

[[inputs.nstat]]
"

echo "$configuration" > /etc/telegraf/telegraf.conf

# start server
exec telegraf
