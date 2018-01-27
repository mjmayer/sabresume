#!/bin/sh
#SABKEY=
SABHOST="${SABHOST:-sabnzbd}"
SABPORT="${SABPORT:-8080}"
PROT="${PROT:http}"
SPACELIMIT="${SPACELIMIT:-20}"
SLEEP="${SLEEP:-300}"
if  ! curl -L -s  "$PROT://${SABHOST}:${SABPORT}/api?apikey=${SABKEY}&output=json&mode=fullstatus" | grep -q 'pid'; then
  echo "Failed to connect to: $PROT://$SABHOST:$SABPORT using apikey $SABKEY"
  exit
fi
exit
PAUSED=$(curl -s -L "$PROT://${SABHOST}:${SABPORT}/api?apikey=${SABKEY}&output=json&mode=queue&search=paused" | jq -r '.["queue"]["paused"]')
FREESPACE=$(curl -s -L "$PROT://${SABHOST}:${SABPORT}/api?apikey=${SABKEY}&output=json&mode=queue&search=paused" | jq -r '.["queue"]["diskspace1"]')
while true; do
   if  [ $(echo "$FREESPACE > $SPACELIMIT" | bc -l) == 1 ] && [ $PAUSED == 'true' ]; then
      RESUMED=$(curl -s -L "$PROT://${SABHOST}:${SABPORT}/api?apikey=${SABKEY}&output=json&mode=resume" | jq -r '.["status"]')
   fi
   if [ $RESUMED ]; then
     DATE=`date '+%Y-%m-%d %H:%M:%S'`
     echo "$DATE: Resumed SABNZBD"
   fi
sleep $SLEEP
done
exit
