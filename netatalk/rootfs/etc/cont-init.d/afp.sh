#!/usr/bin/with-contenv bashio
if id -u "$(bashio::config 'username')" >/dev/null 2>&1; then
  exit 0
else
  echo "user does not exist"
  addgroup "$(bashio::config 'username')"
  adduser -D -H -G "$(bashio::config 'username')" -s /bin/false "$(bashio::config 'username')"
  echo "$(bashio::config 'username'):$(bashio::config 'password')" | chpasswd
  sed -i'' -e "s,%AFP_USER%,$(bashio::config 'username'),g" /etc/afp.conf
fi
