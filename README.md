## ready-to-go - ftp and gridftp docker containers w/ letsencrypt certificates

Fork of https://gitlab.cern.ch/fts/ready-to-go.git.

This repo contains scripts for easy deployment of a gridftp endpoint in a
docker container.

The container will run gridftpd with a host certificate from letsencrypt, which
is renewed automatically. The gridftp server is restricted to `/home`.

The gridftp endpoint will trust client certificates from [EGI IGTF](https://wiki.egi.eu/wiki/EGI_IGTF_Release) and the
[Research and Collaboration Authentication CA Service for
Europe](https://rcauth.eu/).

### Prerequisites

These scripts expect a machine with:

* a public IP address
* docker installed
* docker-compose installed
* ports 80, 2811 and 50000-50200 exposed

### Required environment variables

Upon deployment, the endpoint is configured via some environment variables:

* `DOMAIN` for the endpoint hostname (default: `hostname --fqdn`)
* `EMAIL` required for obtaining a letsencrypt certificate
* `CONTAINERUSERS`: a list of user accounts to create in the container
* `LOCALGRIDMAP`: default user mappings, to be included in `/etc/grid-security/grid-mapfile`

### Example: one-command deployment

In the following example, a cloud instance running CoreOS, with a public IP which resolves to `cloud-instance.provider.com` and
the required ports exposed to the internet has been started.

```
ssh core@cloud-instance.provider.com 'git clone https://github.com/nmb/ready-to-go.git && ready-to-go/script/install-docker-compose.sh && cd ready-to-go/gridftp && LOCALGRIDMAP="\"/DC=eu/DC=rcauth/DC=rcauth-clients/O=ELIXIR/CN=John Doe\" johndoe" CONTAINERUSERS="johndoe" EMAIL="john.doe@example.com" DOMAIN=cloud-instance.provider.com /opt/bin/docker-compose up -d'
```

The command will clone this repository, install docker-compose, and then deploy
a gridftp endpoint with a letsencrypt host certificate.


In order to test the endpoint:
* install the letsencrypt CA on your workstation
* obtain a proxy certificate with a subject matching `LOCALGRIDMAP` above (e.g.
by issuing a proxy cert from rcauth, or via `grid-proxy-init`)
* list files on the endpoint, assuming the proxy cert is in the file `cert.txt`:
`globus-url-copy -cred cert.txt -list gsiftp://cloud-instance.provider.com/home/johndoe/`


