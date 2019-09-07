#!/bin/bash


## NOTE: THIS SCRIPT IS EXPERIMENTAL.
## IN PARTICULAR, THE INIT SCRIPTS MAY NOTWORK AS EXPECTED.


function install_rocketchat_nginx {
  sudo apt install fail2ban nginx python-certbot-nginx -y

  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw enable

  certbot run --nginx -m rgomes.info@gmail.com --agree-tos -n --agree-tos

  cp -p /etc/nginx/sites-available/default{,.CERTBOT}
  cat << EOD > /etc/nginx/sites-available/default
server {
    server_name ${fqdn}; # managed by Certbot
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/chat.mathminds.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/chat.mathminds.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    index index.html index.htm;

    location / {
        proxy_pass http://chat.mathminds.io:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;
        proxy_redirect off; 
    }
}

server {
    listen 80;
    listen [::]:80;
    server_name ${fqdn};

    if (\$host = ${fqdn}) {
        return 301 https://\$host\$request_uri;
    } # managed by Certbot

    return 404; # managed by Certbot
}
EOD
}


function install_rocketchat_services {
  sudo apt install docker-ce docker-ce-cli docker-compose -y
  docker-compose --version

  mkdir -p /opt/rocket.chat/data/{runtime/db,dump}
  cat << EOD > /opt/rocket.chat/docker-compose.yml
db:
  image: mongo
  volumes:
    - ./data/runtime/db:/data/db
    - ./data/dump:/dump
  command: mongod --smallfiles

rocketchat:
  image: rocketchat/rocket.chat:latest
  environment:
    - MONGO_URL=mongodb://db:27017/rocketchat
    - ROOT_URL=https://${fqdn}
    - Accounts_UseDNSDomainCheck=True
  links:
    - db:db
  ports:
    - 3000:3000

hubot:
  image: rocketchat/hubot-rocketchat:latest
  environment:
    - ROCKETCHAT_URL=${ip}:3000
    - ROCKETCHAT_ROOM=GENERAL
    - ROCKETCHAT_USER=Botname
    - ROCKETCHAT_PASSWORD=BotPassw0rd
    - BOT_NAME=Botname
    - EXTERNAL_SCRIPTS=hubot-help,hubot-seen,hubot-links,hubot-greetings
  links:
    - rocketchat:rocketchat
# this is used to expose the hubot port for notifications on the host on port 3001, e.g. for hubot-jenkins-notifier
  ports:
    - 3001:8080
EOD

  cat << EOD > /etc/init/rocketchat_mongo.conf
description "MongoDB service manager for RocketChat"

# Start MongoDB after docker is running
start on (started docker)
stop on runlevel [!2345]

# Automatically Respawn with finite limits
respawn
respawn limit 99 5

# Path to our app
chdir /opt/rocket.chat

script
    exec /usr/local/bin/docker-compose up db
end script
EOD


  cat << EOD > /etc/init/rocketchat_app.conf
description "RocketChat service manager"

# Start Rocketchat only after mongo job is running
start on (started rocketchat_mongo)
stop on runlevel [!2345]

# Automatically Respawn with finite limits
respawn
respawn limit 99 5

# Path to our app
chdir /opt/rocket.chat

script
    exec /usr/local/bin/docker-compose up rocketchat hubot
end script
EOD
}


function install_rocket_chat {
    local fqdn=$(hostname --fqdn)
    local ip=$(dig @ns1.he.net +short ${fqdn} a)

    install_rocketchat_nginx
    install_rocketchat_services

    service nginx            restart

    #service rocketchat_mongo restart
    #service rocketchat_app   restart
    cd /opt/rocket.chat
    docker-compose up
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
