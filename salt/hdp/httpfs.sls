# Install httpfs, note no need to specify version as it comes from the hdp repo mirror
{% set java_home = salt['pillar.get']('java:java_home', '') %}
hdp-httpfs_pkg:
  pkg.installed:
    - name: hadoop-httpfs
    - ignore_epoch: True

hdp-httpfs_create_link:
  file.symlink:
    - name: /etc/init.d/hadoop-httpfs
    - target: /usr/hdp/current/hadoop-httpfs/etc/init.d/hadoop-httpfs

hdp-httpfs_java_home:
  file.append:
    - name: /etc/hadoop-httpfs/conf/httpfs-env.sh
    - text:
      - "export JAVA_HOME={{ java_home }}"

hdp-httpfs_service_started:
  service.running:
    - name: hadoop-httpfs
    - enable: True
    - reload: True


