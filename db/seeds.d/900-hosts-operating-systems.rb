# Defaults for:
# - Hosts > Operating Systems
# - Hosts > Provisioning Templates
# - Hosts > Architectures

Operatingsystem.without_auditing do
  oses = [
    {
      :name             => "Ubuntu",
      :major            => "20",
      :minor            => "04",
      :release_name     => "focal",
      :description      => "Ubuntu 20.04.1 LTS (Focal Fossa)",
      :password_hash    => "SHA256",
      # :family           => "Debian",
      # :architectures    => [:id, :name], :architecture_ids => [], :architecture_names => [],
      # :ptables          => ["Preseed default"],
      # :media            => [],
    },
  ]

  prov_templates = [
    "Preseed default",
    "Preseed default finish",
    "Preseed default PXELinux",
  ]

  target_architectures = [
    "x86_64",
  ]

  install_media = [
    "Ubuntu mirror",
  ]

  oses.each do |os_data|
    os = Operatingsystem.find_or_create_by(os_data)

    prov_templates.each do |tmpl|
      template = ProvisioningTemplate.find_by_name(tmpl)
      # TODO: associate template with os
      # TODO: add template to os.templates
    end

    target_architectures.each do |arch|
      architecture = Architecture.find_by_name(arch)
      # TODO: add os to architecture.oses
    end

    install_media.each do |med|
      medium = Medium.find_by_name(med)
      # TODO: add to os.media
    end
  end
end
