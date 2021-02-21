# Defaults for:
# - Administer > Authentication Sources > LDAP

ldap_servers = [
  {
    :name => "Synology NAS",
    :host => "nas.local",
  },
]

AuthSourceLdap.without_auditing do
  ldap_servers.each do |srv|
    ldap = AuthSourceLdap.find_or_create_by(srv)
  end
end
