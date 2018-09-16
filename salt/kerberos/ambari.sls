Kerberos-amabari-sudoers:
  file.append:
    - name: /etc/sudoers
    - sources:
      - salt://kerberos/files/sudoers.conf
ambari-server-start_service:
  cmd.run:
    - name: 'service ambari-server stop || echo already stopped; service ambari-server start'

