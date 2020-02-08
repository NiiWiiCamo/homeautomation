#!/bin/bash

# $1 = username
# $2 = hostname
# $3 = if [W]indows, defaults to Linux

if [ $# -lt 2 ]
then
  echo "Use 'ssh-shutdown.sh <username> <hostname> <W>, where <W> is optional if target is Windows."
  exit 2
fi

if [ -z $3 ]
then
  ssh $1@$2 'shutdown now'
else
  if [[ "$3" -eq "W" ]]
  then
  ssh $1@$2 'shutdown -s -t 60 -c "Shutdown in 1 Minute from SSH command."'
  fi
fi

