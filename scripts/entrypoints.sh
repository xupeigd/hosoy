# !/bin/bash

sudo service ssh start

sleep $HOLDING_TIME

sh ./run-$MODE.sh

while true; do sleep 1000; done