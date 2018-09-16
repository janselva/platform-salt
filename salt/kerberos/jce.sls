{%- set jce_url     = "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" %}
{%- set dl_opts     = '-b oraclelicense=accept-securebackup-cookie -L -s' %}
{%- set java_home   = '/usr/share/java/jdk1.8.0_131' %}
{%- set jre_lib_sec = java_home + '/jre/lib/security' %}
{%- set zip_file    = salt['file.join'](jre_lib_sec, 'UnlimitedJCEPolicy.zip') %}
{%- set policy_jar  = salt['file.join'](jre_lib_sec, 'US_export_policy.jar') %}
{%- set policy_jar_bak = salt['file.join'](jre_lib_sec, 'US_export_policy.jar.nonjce') %}
Kerberos-java-jce-unzip:
  pkg.installed:
    - name: unzip

Kerberos-remove-old-jce-archive:
  file.absent:
    - name: {{ zip_file }}

Kerberos-download-jce-archive:
  cmd.run:
    - name: curl {{ dl_opts }} -o '{{ zip_file }}' '{{ jce_url }}'
    - creates: {{ zip_file }}
    - onlyif: >
        test ! -f {{ policy_jar }} ||
        test ! -f {{ policy_jar_bak }}

Kerberos-backup-non-jce-jar:
  cmd.run:
    - name: mv US_export_policy.jar US_export_policy.jar.nonjce; mv local_policy.jar local_policy.jar.nonjce;
    - cwd: {{ jre_lib_sec }}
    - creates: {{ policy_jar_bak }}

Kerberos-unpack-jce-archive:
  cmd.run:
    - name: unzip -j -o {{ zip_file }}
    - cwd: {{ jre_lib_sec }}
    - creates: {{ policy_jar }}
    - require:
      - pkg: Kerberos-java-jce-unzip
      - cmd: Kerberos-download-jce-archive
      - cmd: Kerberos-backup-non-jce-jar

Kerberos-Kerberos-remove-jce-archive:
  file.absent:
    - name: {{ zip_file }}
    - require:
      - cmd: Kerberos-unpack-jce-archive
