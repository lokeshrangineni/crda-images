#!/bin/sh
mkdir -p /root/.crda
touch /root/.crda/config.yaml
echo auth_token:${AUTH_TOKEN} >> /root/.crda/config.yaml
echo crda_key:${CRDA_KEY} >> /root/.crda/config.yaml
echo host:${HOST} >> /root/.crda/config.yaml