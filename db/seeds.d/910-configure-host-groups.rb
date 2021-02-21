# Defaults for:
# - Infrastructure > Domains
# - Configure > Host Groups

domains = [
  {
    :name     => "local",
    :fullname => "Internal, local network",
  },
]

host_groups = [
  {
    :name         => "laptops",
    :description  => "Portable workstations",
    # :domain       => "local",
    # :architecture => "x86_64",
    # :os           => "Ubuntu 20.04.1 LTS (Focal Fossa)",
  },
]

Domain.without_auditing do
  domains.each do |dns_data|
    domain = Domain.find_or_create_by(dns_data)
  end
end

Hostgroup.without_auditing do
  host_groups.each do |grp|
    hostgroup = Hostgroup.find_or_create_by(grp)
  end
end
