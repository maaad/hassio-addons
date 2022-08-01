#!/bin/bash

CONFIG_PATH=/data/options.json
USERNAME=$(jq --raw-output ".afp_username" $CONFIG_PATH)
PASSWORD=$(jq --raw-output ".afp_password" $CONFIG_PATH)

addgroup "${USERNAME}"
adduser -D -H -G "${USERNAME}" -s /bin/false "${USERNAME}"
echo "${USERNAME}:${PASSWORD}" | chpasswd


# create config
echo $'[Global]
log file = /dev/stdout
uam list = uams_guest.so uams_dhx2.so uams_dhx.so
hostname = homeassistant.local
force user = root
force group = root
[Share]
path = /share
valid users = %AFP_USER%
[Media]
path = /media
valid users = %AFP_USER%
[Addons]
path = /addons
valid users = %AFP_USER%
[SSL]
path = /ssl
valid users = %AFP_USER%
[Configuration]
path = /config
valid users = %AFP_USER%
[Backup]
path = /backup
valid users = %AFP_USER%
[Time Machine]
path = /backup/timemachine
time machine = yes' >> /etc/afp.conf

# TODO: configure username/password
sed -i'' -e "s,%AFP_USER%,${AFP_USER:-},g" /etc/afp.conf

exec netatalk -F /etc/afp.conf -d
