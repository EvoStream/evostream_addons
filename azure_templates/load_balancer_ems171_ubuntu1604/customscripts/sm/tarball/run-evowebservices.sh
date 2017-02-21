#!/bin/bash
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Start/Restart evowebservices
#

stopevowebservices () {
  `sudo killall -9 node`
  sleep 3
}

startevowebservices () {
  USERNAME=`awk -v val=1001 -F ":" '$3==val{print $1}' /etc/passwd`
  cd /home/$USERNAME/node_modules/evowebservices
  echo 'Starting EVOWEBSERVICES...'
  DEBUG=evowebservices:* npm start &
  sleep 3
}

countlines () {
  COUNT=`ps -ef | grep node | wc -l`
  return $COUNT
}

stopevowebservices
countlines
OLDCOUNT=$?
startevowebservices
LOOPS=20
while [ $LOOPS -gt 0 ]; do
  sleep 1
  countlines
  NEWCOUNT=$?
  if [ "$NEWCOUNT" -gt "$OLDCOUNT" ]; then
    let LOOPS=0
  else
    let LOOPS=LOOPS-1
  fi
done
sleep 3
echo 'EVOWEBSERVICES running...'
