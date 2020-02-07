#!/bin/bash


validate_mac()
{
  local mac=$1
  local stat=1

  if [[ ${mac} =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]]
  then
    stat=$?
  fi
  return ${stat}
}

validate_ip()
{
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
  then
    OIFS=${IFS}
    IFS='.'
    ip=($ip)
    IFS=${OIFS}
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
      && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return ${stat}
}

if [ -z $1 ]
then
  echo "You can use 'wake.sh <target>' where <target> is a MAC, IP or hostname"
  echo "Enter hostname, IP, or MAC address to wake up:"
  read wakeinput
  confirm=1
else
  wakeinput=$1
  confirm=0
fi


if validate_mac ${wakeinput}
then
  echo "Input is a valid MAC address."
  wakemac=${wakeinput}
else
  if validate_ip ${wakeinput}
  then
    echo "Input is a valid IP address."
    wakeip=${wakeinput}
  else
    wakeip=$( host -4 ${wakeinput} | awk '{print $4 ; exit}' )
#    if [ -z $wakeip ]
    if validate_ip ${wakeip}
    then
      echo "Resolved to ${wakeip}."
    else
      echo "Could not resolve to IP address."
      exit 2
    fi
  fi
  wakemac=$( ip neighbor show ${wakeip} | awk '{print $5}' )
  if validate_mac ${wakemac}
  then
    echo "Resolved to ${wakemac}."
  else
    echo "Could not resolve to MAC address!"
    exit 2
  fi
fi
if [ ${confirm} -eq 0 ]
then
  wakeonlan ${wakemac}
else
  echo "Wake up ${wakemac} ? [Y/n]"
  read -s -r -n 1 response
  case ${response} in
    [nN])
      echo "Okay then.";
      exit;;
    *)
      wakeonlan ${wakemac};
      exit;;
  esac
fi
