
{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set misc_packages_path = pillar['pnda_mirror']['misc_packages_path'] %}
{% set mirror_location = pnda_mirror + misc_packages_path %}

{% set jetty_version = pillar['jetty']['version'] %}
{% set jetty_package = 'jetty-distribution-' + jetty_version + '.tar.gz' %}
{% set jetty_url = mirror_location + jetty_package %}
{% set jetty_directory = pillar['jetty']['directory'] + '/jetty' %}


{% set jolokia_version = pillar['jolokia']['version'] %}
{% set jolokia_package = 'jolokia-war-' + jolokia_version + '.war' %}
{% set jolokia_url = mirror_location + jolokia_package %}
{% set jolokia_directory = pillar['jolokia']['directory']+ '/jolokia' %}

include:
  - java

jetty-jetty_user:
  group.present:
    - name: jetty
  user.present:
    - name: jetty
    - gid_from_name: True
    - groups:
      - jetty

jetty-installation:
  archive.extracted:
    - name: {{ jetty_directory }}
    - source: {{ jetty_url }}
    - source_hash: {{ jetty_url }}.sha1
    - user: jetty
    - group: jetty
    - archive_format: tar
    - tar_options: --strip-components=1
    - if_missing: {{ jetty_directory }}/bin/jetty

jetty-copy_start.ini_file:
  file.managed:
    - name: {{ jetty_directory }}/start.ini
    - source: salt://jetty/templates/start.ini
    - backup: bak
    - template: jinja

jetty-create_syslink:
  file.symlink:
    - name: /etc/init.d/jetty
    - target: {{ jetty_directory }}/bin/jetty.sh
    - force: True

jetty-add_chkconfig:
  cmd.run:
    - name: chkconfig --add jetty
    - unless: chkconfig --list jetty

jetty-add_chkconfig_level:
  cmd.run:
    - name: chkconfig --level 345 jetty on



jetty-create_dir_for_jetty_run:
  file.directory:
    - name: /var/run/jetty
    - user: jetty
    - group: jetty
    - force: True


jetty-copy_jetty_file:
  file.managed:
    - name: /etc/default/jetty
    - source: salt://jetty/templates/jetty
    - backup: bak
    - template: jinja


jetty_jolokia-installation:
  file.managed:
    - name: {{ jetty_directory }}/webapps/jolokia.war
    - source: {{ jolokia_url }}
    - source_hash: {{ jolokia_url }}.sha1
    - user: jetty
    - group: jetty

jetty_service_start:
    service.running:
      - name: jetty
      - enabled: True
      - watch:
          - file: {{ jetty_directory }}/webapps/jolokia.war
          - file: /etc/default/jetty
          - file: {{ jetty_directory }}/start.ini
