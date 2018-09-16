{%- set domain = salt['grains.get']('domain') -%}
{%- set realm = domain|upper -%}
{%- set kdc_hostname = salt['grains.get']('fqdn') -%}

kerberos-kdc_install:
  pkg.installed:
    - names:
      - krb5-server
      - krb5-libs
      - krb5-workstation

kerberos-krb5_conf:
  file.managed:
    - name: /etc/krb5.conf
    - source: salt://kerberos/templates/krb5.conf.tpl
    - template: jinja
    - defaults:
        realm: {{ realm }}
        kdc_hostname: {{ kdc_hostname }}
        domain_name: {{ domain }}

kerberos-kdc_conf:
  file.managed:
    - name: /var/kerberos/krb5kdc/kdc.conf
    - source: salt://kerberos/templates/kdc.conf.tpl
    - template: jinja
    - defaults:
        realm: {{ realm }}
 
kerberos-kadm5_conf:
  file.managed:
    - name: /var/kerberos/krb5kdc/kadm5.acl
    - source: salt://kerberos/templates/kadm5.acl.tpl
    - template: jinja
    - defaults:
        realm: {{ realm }}
#addd databse 

Kerberos-add_admin_principal:
  cmd.run:
   - name:  kadmin.local -q "addprinc -pw cisco.123 admin/admin"
 
kerberos-kdc_service_started:
  service.running:
    - name: krb5kdc
    - enable: True
    - reload: True

kerberos-kadmin_service_started:
  service.running:
    - name: kadmin
    - enable: True
    - reload: True
