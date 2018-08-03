
{% set java_home = salt['pillar.get']('java:java_home', '') %}

java-install_dependencies:
  pkg.installed:
    - name: {{ pillar['java']['package-name'] }}
    - version: {{ pillar['java']['version'] }}
    - ignore_epoch: True

jdk-config:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://java/java.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      java_home: {{ java_home }}

java-java_alternatives:
  alternatives.install:
    - name: java
    - link: /usr/bin/java
    - path: {{ java_home }}/bin/java
    - priority: 100

java-java_alternatives-force-alternative:
  alternatives.set:
    - name: java
    - path: {{ java_home }}/bin/java
    - require:
      - alternatives: java-java_alternatives

java-javac_alternatives:
  alternatives.install:
    - name: javac
    - link: /usr/bin/javac
    - path: {{ java_home }}/bin/javac
    - priority: 100

java-javac_alternatives-force-alternative:
  alternatives.set:
    - name: javac
    - path: {{ java_home }}/bin/javac
    - require:
      - alternatives: java-javac_alternatives

java-jar_alternatives:
  alternatives.install:
    - name: jar
    - link: /usr/bin/jar
    - path: {{ java_home }}/bin/jar
    - priority: 100

java-jar_alternatives-force-alternative:
  alternatives.set:
    - name: jar
    - path: {{ java_home }}/bin/jar
    - require:
      - alternatives: java-jar_alternatives

java-keytool_alternatives:
  alternatives.install:
    - name: keytool
    - link: /usr/bin/keytool
    - path: {{ java_home }}/bin/keytool
    - priority: 100

java-keytool_alternatives-force-alternative:
  alternatives.set:
    - name: keytool
    - path: {{ java_home }}/bin/keytool
    - require:
      - alternatives: java-keytool_alternatives
