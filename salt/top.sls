{{ env }}:

  '*':
    - volumes
    - tasks.system_update
    - motd
    - pnda.user
    - identity.users
    - hostsfile
    - self-registration.node
    - self-registration.service
    - java
    - ntp
    - logserver.logshipper

  'roles:zookeeper':
    - match: grain
    - zookeeper

  'roles:kafka':
    - match: grain
    - kafka.server

  'roles:kafka_tool':
    - match: grain
    - kafka-tool

  'roles:kafka_manager':
    - match: grain
    - kafka-manager

  'roles:platform_testing_general':
    - match: grain
    - jmxproxy
    - platform-testing.general

  'roles:logserver':
    - match: grain
    - curator
    - elasticsearch
    - kibana
    - logserver.logserver

  'roles:kibana_dashboard':
    - match: grain
    - kibana.kibana-dashboard

  'roles:console_frontend':
    - match: grain
    - nginx
    - console-frontend

  'roles:console_backend_data_logger':
    - match: grain
    - console-backend.data-logger

  'roles:console_backend_data_manager':
    - match: grain
    - console-backend.data-manager
    - login

  'roles:graphite':
    - match: grain
    - graphite-api

  'roles:grafana':
    - match: grain
    - grafana

  'roles:opentsdb':
    - match: grain
    - snappy

  'hadoop:*':
    - match: grain
    - cdh.create_data_dirs
    - snappy
    - anaconda

  'roles:mysql_connector':
    - match: grain
    - mysql.connector

  'roles:oozie_database':
    - match: grain
    - cdh.oozie_mysql

  'roles:package_repository':
    - match: grain
    - package-repository

  'roles:deployment_manager':
    - match: grain
    - deployment-manager.generate_keys

  'roles:knox':
    - match: grain
    - login

  'roles:jupyter':
    - match: grain
    - login
