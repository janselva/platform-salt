{% set volume_mappings = salt['cmd.shell']('cat /etc/pnda/disk-config/volume-mappings') %}

{% for line in volume_mappings.split('\n') %}
  {% set parts = line.split(' ') %}
  {% set device = parts[0] %}
  {% set mountpoint = parts[1] %}
  {% set fs_type = parts[2] %}

  volumes-format-{{ device }}:
    blockdev.formatted:
      - name: {{ device }}
      - fs_type: {{ fs_type }}

  volumes-mount-{{ device }}:
    mount.mounted:
      - name: {{ mountpoint }}
      - device: {{ device }}
      - fstype: {{ fs_type }}
      - mkmnt: True
{% endfor %}