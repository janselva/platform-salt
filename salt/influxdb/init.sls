{% set database = pillar['influxdb']['database'] %}
{% set INFLUX_RETENTION_POLICY_NAME = pillar['influxdb']['retention_policy_name'] %}
{% set INFLUX_RETENTION_POLICY_VALUE = pillar['influxdb']['retention_policy_value'] %}
{% set policy = 'create retention policy '+ INFLUX_RETENTION_POLICY_NAME + ' on ' + database +  ' Duration ' +  INFLUX_RETENTION_POLICY_VALUE + ' Replication 1 DEFAULT' %}

influxdb-install:
  pkg.installed:
    - name: influxdb
    - version: {{ pillar['influxdb']['version'] }}

influxdb_create_dir:
  file.directory:
    - name: /mnt/influxdb
    - user: influxdb
    - group: influxdb
    - makedirs: True

influxdb_configure_influxdb_conf_file:
  file.managed:
    - name: /etc/influxdb/influxdb.conf
    - source: salt://influxdb/templates/influxdb.conf
    - backup: minion
    - template: jinja

influxdb_restart_influxdb:
  service.running:
    - name: influxdb
    - enable: True
    - watch:
        - file: /etc/influxdb/influxdb.conf
        

influxdb_sleep:
  cmd.run:
    - name: sleep 5

influxdb_create_database:
  cmd.run:
    - name: influx -execute 'create database {{ database }}'
    
influxdb_create_retention_policy:
  cmd.run:
    - name: influx -execute "{{ policy }}"


    
    
    