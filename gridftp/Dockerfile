FROM centos:7

# Required repositories
RUN yum install -y epel-release
ADD "http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo" "/etc/yum.repos.d"

# ROOT CAs
RUN yum install -y lcg-CA

# Server software
RUN yum install -y openssl edg-mkgridmap globus-gridftp-server globus-gridftp-server-progs
RUN yum install -y supervisor cronie

# GridFTP ports
EXPOSE 2811 50000-50200

# Grid mapfile
ADD "image/edg-mkgridmap.cron" "/etc/cron.d"

# Optional explicit user mapping
ARG LOCALGRIDMAP
RUN echo $LOCALGRIDMAP >> /etc/localgridmap.conf

# Add user accounts
ARG CONTAINERUSERS
RUN for u in $CONTAINERUSERS; do if [ $u ]; then adduser -m -c '' $u; fi; done

# Let's Encrypt
RUN yum install -y certbot
ADD "image/certbot.cron" "/etc/cron.d/"
ADD "image/letsencrypt.sh" "/usr/local/bin"
EXPOSE 80

ADD "https://letsencrypt.org/certs/isrgrootx1.pem.txt" "/etc/grid-security/certificates/isrgrootx1.pem"
RUN ln -s "/etc/grid-security/certificates/isrgrootx1.pem" "/etc/grid-security/certificates/4042bcee.0"

# Add rcauth CA
ADD "http://rcauth.eu/pilot/g1/ca/cacert.pem" "/etc/grid-security/certificates/rcauth.eu.pem"
ADD "https://rcauth.eu/pilot/rcauth-pilot-ica-g1.signing_policy" "/etc/grid-security/certificates/rcauth.eu.signing_policy"
RUN /bin/bash -c 'export HASH=`openssl x509 -in /etc/grid-security/certificates/rcauth.eu.pem -noout -hash`;\
cd /etc/grid-security/certificates/;\
ln -s rcauth.eu.pem $HASH.0;\
ln -s rcauth.eu.signing_policy $HASH.signing_policy'

# Supervisord config file
ADD "image/supervisord.ini" "/etc/supervisord.ini"

# Entry point
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisord.ini"]

