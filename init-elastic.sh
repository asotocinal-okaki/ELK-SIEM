#!/usr/bin/env bash

# create certs
if [[ ! -d config/certificates/certs ]]; then
    mkdir config/certificates/certs;
fi;
if [[ ! -f /local/certs/bundle.zip ]]; then
    bin/elasticsearch-certgen --silent --in config/certificates/instances.yml --out config/certificates/certs/bundle.zip;
    unzip config/certificates/certs/bundle.zip -d config/certificates/certs; 
fi;
chgrp -R 0 config/certificates/certs