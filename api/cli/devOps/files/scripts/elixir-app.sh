#!/bin/bash


export LOCAL_IP=$(cat /etc/hosts | awk '{print $1}' | tail -n 1 | tr -d '\n')

envconsul -log-level=err -consul-addr=172.17.0.2:8500 -prefix common- \
 -exec-kill-signal=SIGTERM -exec-kill-timeout=10m /opt/elixir-app/bin/api start
