reactor-hadoop_service_start:
  local.state.single:
    - arg:
      - hadoop_service.start
    - tgt: {{ data['data']['id'] }}
    - timeout: 120
    - queue: True
