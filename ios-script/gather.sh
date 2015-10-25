#!/bin/bash

while true; do
wget -O - "http://172.31.33.11:8080/dat?`head -1 < /dev/tty.iap`"
sleep 2
done

