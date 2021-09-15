Synology Foreman
================

Infrastructure configuration management setup

- using [The Foreman](https://theforeman.org/) (Docker-based) as a
  [Puppet ENC](https://puppet.com/docs/puppet/7.1/nodes_external.html)
- on a [Synology NAS](https://www.synology.com/en-global/products/series/home) (e.g. DS918+ running DSM 7.0)
- and a modern router (e.g. [Synology RT2600ac](https://www.synology.com/en-global/products/RT2600ac) running SRM 1.2.5).

Base Setup (Synology DSM)
-------------------------

1. [Enable SynoCommunity](https://synocommunity.com/) in Package Center
1. Install: Docker, Git ([GitHub #3375](https://github.com/SynoCommunity/spksrc/issues/3375#issuecomment-407526024)),
   OpenLDAP _or_ Active Directory ([example](https://blog.cubieserver.de/2018/synology-nas-samba-nfs-and-kerberos-with-freeipa-ldap/))
   ```bash
   # FILE: $HOME/.bashrc (inspired by: /etc.defaults/.bashrc_profile)
   PS1='\[\033[01;32m\]\u@\h\[\033[0m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
   export PATH="$PATH:/usr/local/bin"
   alias ll='ls -lAF'
   ```
1. Terminal: Activate SSH

The Foreman Setup (ENC)
-----------------------

1. Generate a Docker Compose setup tailored to your needs:
   ```console
   tools/generate-docker-compose.sh
   ```
1. Use Docker Compose to [set up The Foreman](
   https://github.com/theforeman/foreman/blob/develop/developer_docs/containers.asciidoc)

### Set up initial values

1. Create OS (Hosts > Operating Systems)
1. Create domain (Infrastructure > Domains)
1. Create host group (Configure > Host Groups)
1. Configure AD integration (Administer > LDAP Auth)
1. Configure reduced UI for unprivileged users

This can be done using The Foreman's [official Ansible modules](
https://theforeman.github.io/foreman-ansible-modules/develop/plugins/).

Make sure you have Ansible 2.9+ installed, then run:

```console
ansible-galaxy collection install theforeman.foreman
```

Adapt the Ansible setup in `init/` to your liking, then run the playbook:

```console
export FOREMAN_SERVER_URL=http://0.0.0.0:3000
export FOREMAN_USERNAME=admin
export FOREMAN_PASSWORD=changeme
ansible-playbook init/playbook.yml
```

Network Boot (PXE/TFTP)
-----------------------

[How to implement PXE with Synology NAS](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General/How_to_implement_PXE_with_Synology_NAS) (official)

1. Activate TFTP service (Control Panel > File Services > Advanced > TFTP)
1. Configure DHCP service (on router) or on the Synology NAS (DHCP Server > PXE)

Alternatively, you can activate PXE on the router if the DHCP service supports
the `next-server` option. This will officially be supported by Synology routers
(and available in their GUI) from SRM 2.0 onwards. Here is the manual setup for
SRM < 2.0:

```ini
# FILE: /etc/dhcpd/dhcpd-lbr0-pxe.conf
# replace boot image and IP address by your TFTP host values
dhcp-boot=tag:lbr00,pxelinux.0,tftpserver,10.0.4.2
dhcp-boot=tag:x86PC,pxelinux.0,,10.0.4.2
dhcp-boot=tag:EFI_ia32,grub2/shim.efi,,10.0.4.2
dhcp-boot=tag:BC_EFI,grub2/shim.efi,,10.0.4.2
dhcp-boot=tag:EFI_x86-64,grub2/shim.efi,,10.0.4.2
dhcp-match=x86PC,option:client-arch,0
dhcp-match=EFI_ia32,option:client-arch,6
dhcp-match=BC_EFI,option:client-arch,7
dhcp-match=EFI_x86-64,option:client-arch,9
dhcp-option=tag:lbr00,vendor:PXEClient,1,10.0.4.2
```
```ini
# FILE: /etc/dhcpd/dhcpd-lbr0-pxe.info
enable="yes"
```

Then run `/etc/rc.network nat-restart-dhcp` or reboot your router. This
will configure PXE on the "lbr0" interface in `/etc/dhcpd/dhcpd.conf`.
Note: By using a separate configuration file this setup should even survive
SRM upgrades on the router (take this with a grain of salt).
