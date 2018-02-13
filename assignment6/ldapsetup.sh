#!/usr/bin/env bash
# info found https://www.itzgeek.com/how-tos/linux/centos-how-tos/step-step-openldap-server-configuration-centos-7-rhel-7.html
## NB!!
#Country Name (2 letter code) [XX]: XX
#State or Province Name (full name) []: XX
#Locality Name (eg, city) [Default City]: XXXXXX
#Organization Name (eg, company) [Default Company Ltd]:ITzGeek
#Organizational Unit Name (eg, section) []:IT Infra
#Common Name (eg, your name or your server's hostname) []:server.dat151.local
#Email Address []:admin@dat151.com

# run this with sudo
# enter into hosts file
echo "192.168.12.10 server.dat151.local server
      192.168.12.20 client.dat151.local client" >> /etc/hosts

#Install ldap
#yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel

#Start and enable ldap-service
systemctl start slapd.service
systemctl enable slapd.service

#Set LDAP root password
slappasswd -s ldap

#Configure with LDAP-server with diffs
## setup passwords and database with cn and dc
ldapmodify -Y EXTERNAL  -H ldapi:/// -f db.ldif
## restrict the monitor access only to ldap root (ldapadm) user not to others
ldapmodify -Y EXTERNAL  -H ldapi:/// -f monitor.ldif

#Generate certificate and change its owner to ldap
openssl req -new -x509 -nodes -out /etc/openldap/certs/dat151ldapcert.pem -keyout /etc/openldap/certs/dat151dapkey.pem -days 365
chown -R ldap:ldap /etc/openldap/certs/*.pem

#Configure LDAP to use secure communication using the generated certificate
ldapmodify -Y EXTERNAL  -H ldapi:/// -f certs.ldif

#Copy example db
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/*

#Add the cosine and nis LDAP schemas.
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

##Build the shared directory structure with the diff and add the user with dc:
ldapadd -x -W -D "cn=ldapadm,dc=dat151,dc=local" -f base.ldif
