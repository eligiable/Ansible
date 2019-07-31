#!/bin/bash
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
make test
make install
cd utils
./install_server.sh
service redis_6379 start
# update-rc.d redis_6379 defaults
sudo systemctl enable redis_6379
