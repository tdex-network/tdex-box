#!/bin/bash

TOR=false

if $TOR ; then
    cd /home/ubuntu/tdex-box && export EXPLORER=EXPLR; export ONION_KEY=base64PK; /usr/local/bin/docker-compose -f docker-compose-tor.yml up -d
else
    cd /home/ubuntu/tdex-box && export EXPLORER=EXPLR; /usr/local/bin/docker-compose -f docker-compose.yml up -d
fi
