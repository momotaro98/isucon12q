#!/bin/bash

source $HOME/.bashrc

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo 'Restarting Go...'
# cd $DIR/go
# go build -o isucondition
sudo systemctl stop isuports.service
cd $DIR
sudo systemctl restart isuports.service
echo 'Restarted!'

sudo cp $DIR/systemd/* /etc/systemd/system/
sudo systemctl daemon-reload

echo 'Updating config file...'
sudo cp "$DIR/nginx.conf" /etc/nginx/nginx.conf
# sudo cp "$DIR/redis.conf" /etc/redis/redis.conf
sudo cp "$DIR/mysqld.cnf" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo cp "$DIR/10_schema.sql" /home/isucon/webapp/sql/tenant/10_schema.sql
echo 'Updated config file!'

echo 'Restarting services...'
# sudo systemctl restart redis.service
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
echo 'Restarted!'

echo 'Rotating files'
sudo bash -c 'cp /var/log/nginx/access.log /var/log/nginx/access.log.$(date +%s) && echo > /var/log/nginx/access.log'
sudo bash -c 'cp /var/log/mysql/slow.log /var/log/mysql/slow.log.$(date +%s).$(git rev-parse HEAD) && echo > /var/log/mysql/slow.log'
echo 'Rotated!'
