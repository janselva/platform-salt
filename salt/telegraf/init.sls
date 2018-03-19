
telegraf-install:
  pkg.installed:
    - name: telegraf
    - version: {{ pillar['telegraf']['version'] }}


telegraf-configure_telegraf_conf_file:
  file.managed:
    - name: /etc/telegraf/telegraf.conf
    - source: salt://telegraf/templates/telegraf.conf
    - backup: bak
    - template: jinja
    
telegraf-adduser:
  group.present:
    - name: telegraf
  user.present:
    - name: telegraf
    - gid_from_name: True
    - groups:
      - telegraf      
      
telegraf_service_restart:
  service.running:
    - name: telegraf
    - enable: True
    - watch:
        - file: /etc/telegraf/telegraf.conf