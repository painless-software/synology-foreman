Synology Foreman
================

Infrastructure configuration management setup

- using [The Foreman](https://theforeman.org/) (Docker-based) as a
  [Puppet ENC](https://puppet.com/docs/puppet/7.1/nodes_external.html)
- on a [Synology NAS](https://www.synology.com/en-global/products/series/home) (e.g. DS918+ running DSM 6.2.3)
- and a modern router (e.g. [Synology RT2600ac](https://www.synology.com/en-global/products/RT2600ac) running SRM 1.2.4).

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

This can be done using the [hammer-cli-foreman](https://github.com/theforeman/hammer-cli-foreman):

```console
tools/install-hammercli-ubuntu.sh
```

Network Boot (PXE/TFTP)
-----------------------

[How to implement PXE with Synology NAS](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General/How_to_implement_PXE_with_Synology_NAS) (official)

1. Activate TFTP service (Control Panel > File Services > TFTP/PXE > TFTP)
1. Configure DHCP service (on router) or on the Synology NAS (Control Panel > File Services > TFTP/PXE > PXE)

Alternatively, you can activate PXE on the router if the DHCP service supports
the `next-server` option. This will officially be supported by Synology routers
(and available in their GUI) from SRM 2.0 onwards. Here is the manual setup for
SRM < 2.0:

```ini
# FILE: /etc/dhcpd/dhcpd-lbr0-lbr00.conf
interface=lbr0
# replace boot path and IP address by your TFTP host values
dhcp-boot=tag:pxe,/boot,bootserver,192.168.5.5
dhcp-vendorclass=set:pxe,PXEClient
```

Then run `/etc/rc.network nat-restart-dhcp` and verify that the "lbr0"
interface is configured in `/etc/dhcpd/dhcpd.conf` with the PXE settings.
Note that all this must be reapplied after any router SRM upgrade.
