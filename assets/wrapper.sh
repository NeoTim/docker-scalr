#!/bin/bash

if [[ ! -d /etc/scalr-server ]]; then
    mkdir -p /etc/scalr-server
fi
if [[ ! -d /opt/scalr-server ]]; then
    mkdir -p /opt/scalr-server
fi
if [[ ! -f /etc/scalr-server/scalr-server.rb ]]; then
    echo "BOOTSTRAP - Generating default settings"
    mv /etc/scalr-server-template/scalr-server.rb /etc/scalr-server/scalr-server.rb
    chmod 644 /etc/scalr-server/scalr-server.rb
fi
if [[ ! -f /etc/scalr-server/scalr-server-secrets.json ]]; then
    echo "BOOTSTRAP - Setting initial credentials"
    mv /etc/scalr-server-template/scalr-server-secrets.json /etc/scalr-server/scalr-server-secrets.json
    chmod 600 /etc/scalr-server/scalr-server-secrets.json

    ADMINPW=$(grep "admin_password" /etc/scalr-server/scalr-server-secrets.json |awk -F \" '{print $4}')
    echo "BOOTSTRAP - Initial admin password: ${ADMINPW}"
fi
if [[ ! -f /opt/scalr-server/version-manifest.json ]]; then
    echo "BOOTSTRAP - Populating scalr-server data directory"
    mv /opt/scalr-server-template/* /opt/scalr-server
fi

/opt/scalr-server/embedded/bin/python /opt/scalr-server/embedded/bin/supervisord -c /opt/scalr-server/etc/supervisor/supervisord.conf -n
