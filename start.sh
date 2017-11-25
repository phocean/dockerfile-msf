#!/bin/bash
docker build --no-cache -t phocean/msf .
docker run --rm -i -t -p 9990-9999:9990-9999 -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data --name msf phocean/msf