#!/bin/sh
#SABKEY=
SABHOST="${SABHOST:-sabnzbd}"
SABPORT="${SABPORT:-8080}"
PROT="${PROT:-http}"
SPACELIMIT="${SPACELIMIT:-20}"
SLEEP="${SLEEP:-300}"
BASE_URI="$PROT://${SABHOST}:${SABPORT}/api?apikey=${SABKEY}"
DEBUG=true
#logging function. Writes message to stdout
function log {
    echo "[$(date -Iseconds)]: $*"
}

function isSabUp {
  if  ! curl -L -s --insecure "${BASE_URI}&output=json&mode=fullstatus" | grep -q 'pid'; then
    log "Failed to connect to: $PROT://$SABHOST:$SABPORT using apikey $SABKEY"
  elif curl -L -s --insecure "${BASE_URI}&output=json&mode=fullstatus" | grep -q 'pid'; then 
    log "Succesful connection made to ${BASE_URI}"
  else
    log "Unexpected result from attempting to connect to sabnzbd"
  fi
}
while true; do
   if isSabUp; then
       PAUSED=$(curl -s -L --insecure "${BASE_URI}&output=json&mode=queue&search=paused" | jq -r '.["queue"]["paused"]')
       FREESPACE=$(curl -s -L --insecur "${BASE_URI}&output=json&mode=queue&search=paused" | jq -r '.["queue"]["diskspace1"]')   
       if  [ $(echo "$FREESPACE > $SPACELIMIT" | bc -l) == 1 ] && [ $PAUSED == 'true' ]; then
          RESUMED=$(curl -s -L --insecure "${BASE_URI}&output=json&mode=resume" | jq -r '.["status"]')
       fi
       if [ $RESUMED ]; then
          log "Resumed sabznbd" 
       elif [ ! $RESUMED ]; then
          log "Freespace is: $FREESPACE"
          log "Sabnzbd Paused: $PAUSED"
       fi 
   fi
sleep $SLEEP
done
exit
