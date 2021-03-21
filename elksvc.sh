#!/usr/bin/env bash

COMMAND=$1

# TODO:// add command and option checking

# TODO: case statement

# script starts all services in order.
# up () {
# # TODO: add start up code here
# }

# down () {
# # TODO: add teardown code here
# }

# start ES01 - master node
docker-compose up -d es01

# make sure service is up by waiting 10s; TODO: check actual docker service health or port
sleep 20

# generate built-in passwords
echo 'Autogenerating built-in user passwords...'
docker-compose exec -w '/usr/share/elasticsearch' es01 bin/elasticsearch-setup-passwords auto -b > builtins.txt

# Extract kibana frontend pass
export KIBANA_PASS=$(echo -n $(docker-compose exec -w '/usr/share/elasticsearch' es01 grep -o '^PASSWORD kibana = .*$' builtins.txt | cut -d ' ' -f 4 ))

# set password on kibana.yml
sed -i "s/\(elasticsearch.password: \).*$/\1${KIBANA_PASS}/" kibana.yml

echo ${KIBANA_PASS}
echo 'Bringing up kib01'
# bring up kibana
docker-compose up -d kib01