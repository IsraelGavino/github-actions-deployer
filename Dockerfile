#!/usr/bin/env bash

mkdir /root/.ssh
cp /ordenador_jose_sampedro /root/.ssh
touch /root/.ssh/known_hosts
touch /root/.ssh/config

chmod 700 /root/.ssh/
chmod 600 /root/.ssh/*
chmod u+w /root/.ssh/known_hosts

chown -R root:root /root/.ssh/

ssh-keyscan -p 51516 -t rsa,dsa 51.91.94.250 >> ~/.ssh/known_hosts

ssh -p51516 -i ~/.ssh/ordenador_jose_sampedro oscdenox@51.91.94.250 "bash -s" -- < /script1.sh
