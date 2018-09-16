# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  dns_lookup_realm = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  rdns = false
  default_realm = {{ realm }}
  default_ccache_name = KEYRING:persistent:%{uid}

[realms]
  {{ realm }} = {
  kdc = {{ kdc_hostname }}
  admin_server = {{ kdc_hostname }}
  }

[domain_realm]
  .{{ domain_name }} = {{ realm }}
  {{ domain_name }} = {{ realm }}
