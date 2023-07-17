#!/bin/bash

interface="ens160"
dumpdir="/tmp/"

while true; do
  pkt_old=$(grep "$interface:" /proc/net/dev | cut -d : -f2 | awk '{ print $2 }')
  sleep 1
  pkt_new=$(grep "$interface:" /proc/net/dev | cut -d : -f2 | awk '{ print $2 }')

  pkt=$(( pkt_new - pkt_old ))
  echo -ne "\r$pkt packets/s\033[0K"

  if [ $pkt -gt 5 ]; then
    echo -e "\n$(date) Under attack, dumping packets."
    tcpdump -n -s0 -c 2000 -w "$dumpdir/dump.$(date +"%Y%m%d-%H%M%S").cap"
    echo "$(date) Packets dumped, sleeping now."
    
  fi

  sleep 3
done

