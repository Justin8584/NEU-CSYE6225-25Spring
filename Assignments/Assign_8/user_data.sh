#!/bin/bash

mkdir -p /usr/bin/csye6225

cat > /usr/bin/csye6225/.env << EOL
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_USERNAME=${db_username}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
EOL

chmod 600 /usr/bin/csye6225/.env
chown csye6225:csye6225 /usr/bin/csye6225/.env

systemctl start webapp.service
