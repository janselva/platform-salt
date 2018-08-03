[Unit]
Description=JMXProxy service

[Service]
Type=simple
ExecStart={{ java_home }}/bin/java -jar {{ install_dir }}/jmxproxy.jar server {{ install_dir }}/etc/jmxproxy.yaml
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
