#!/usr/bin/env bash

ELASTIC_PASSWORD=$1
CERTS_DIR=$2

if [[ -f "${CERTS_DIR}/elastic-certificates.p12" ]]; then
     rm -rf ${CERTS_DIR}/elastic-certificates.p12
 fi
bin/elasticsearch-certutil cert -v --out ${CERTS_DIR}/elastic-certificates.p12 --pass ${ELASTIC_PASSWORD}


chown -R 1000:0 /usr/share/elasticsearch

# Create keystore and saves ssl keystore password(NOTE: keystore has been created with NO PASSWORD! change password manually with 
# bin/elasticsearch-keystore passwd after all services are up)
# sh genpass.sh ${ELASTIC_PASSWORD}

# Add passwords to keystore
bin/elasticsearch-keystore create
printf ${ELASTIC_PASSWORD} | bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password -x
printf ${ELASTIC_PASSWORD} | bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password -x

# start elasticsearch service as user elasticsearch
su - elasticsearch -c "bin/elasticsearch"

# job id as exit status
# exit $!


# set up built-in passwords. Use auto-pass.txt passwords to connect services to Elasticsearch(eg, kibana)
# does not work, needs to be set up manually(docker exec -it bash then run command)
# nc -z localhost 9200
# while [[ $? -eq 1 ]]; do
#     echo "elasticsearch service not up, retrying in 5s..."
#     sleep 5
#     nc -z localhost 9200
# done

# bin/elasticsearch-setup-passwords auto -b > builtins.txt
