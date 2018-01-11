{% set roles = salt['grains.get']('roles', '') %}
{% set role = salt['grains.get']('hadoop:role', '') %}
config-beacon_create_conf_file:
  file.managed:
    - name: /etc/salt/minion.d/beacons.conf
    - contents: 
      - "beacons:"
      - "  kernel_reboot:"
      - "    interval: 30"
      - "    disable_during_state_run: True"
