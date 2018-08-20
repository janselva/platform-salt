{% set flavor_cfg = pillar['pnda_flavor']['states'][sls] %}
{% set pnda_home = pillar['pnda']['homedir'] %}
{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set misc_packages_path = pillar['pnda_mirror']['misc_packages_path'] %}
{% set mirror_location = pnda_mirror + misc_packages_path %}
{% set opentsdb_home = pnda_home + '/opentsdb' %}
{% set opentsdb_port = pillar['opentsdb']['bind_port'] %}
{% set java_home = salt['pillar.get']('java:java_home', '') %}

include:
  - gnuplot
  - java

opentsdb-server:
  pkg.installed:
    - sources:
      - opentsdb: {{ mirror_location+pillar['opentsdb']['package-source'] }}

opentsdb-home:
  file.directory:
    - name: {{ opentsdb_home }}
    - makedirs: True

opentsdb-logdir:
  file.directory:
    - name: /var/log/pnda/opentsdb
    - makedirs: True

opentsdb-log_config:
  file.managed:
    - name: /etc/opentsdb/logback.xml
    - source: salt://opentsdb/templates/opentsdb_logback.xml.tpl
    - context:
      log_folder: /var/log/pnda/opentsdb
    - template: jinja

opentsdb-copy_defaults:
  file.managed:
    - name: {{ opentsdb_home }}/opentsdb_env.sh
    - source: salt://opentsdb/templates/opentsdb.default.tpl
    - context:
      heap_size: {{ flavor_cfg.opentsdb_heapsize }}
      java_home: {{ java_home }}
    - template: jinja

opentsdb-create_start_script:
  file.managed:
    - name: {{ opentsdb_home }}/start.sh
    - source: salt://opentsdb/templates/opentsdb.start.tpl
    - mode: 754
    - context:
      home: {{ opentsdb_home }}
    - template: jinja

opentsdb-copy_service:
  file.managed:
    - name: /usr/lib/systemd/system/opentsdb.service
    - source: salt://opentsdb/templates/opentsdb.service.tpl
    - template: jinja
    - context:
      home: {{ opentsdb_home }}
      opentsdb_port: {{ opentsdb_port }}
      java_home: {{ java_home }}

opentsdb-systemctl_reload:
  cmd.run:
    - name: /bin/systemctl daemon-reload; /bin/systemctl enable opentsdb

opentsdb-start_service:
  cmd.run:
    - name: 'service opentsdb stop || echo already stopped; service opentsdb start'
