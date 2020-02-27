#!/bin/bash

CIDR=$1

separateip() {
local ip=$1
echo ${ip%/*}
}

separatenetmask() {
local netmask=$1
echo ${netmask#*/}
}

cleanip() {
local ip=$1
clean=${ip//\.00/\.}
clean=${clean//\.0/\.}
clean=${clean//\.\./\.0\.}
echo ${clean}
}

iptobin() {
local ipbin=""
CONV=({0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1})
for byte in $(echo $1 | tr "." " ")
do
  ipbin="${ipbin}${CONV[${byte}]}"
done
echo ${ipbin}
}


netmasktobin() {
local nmbin=""
for ((i=$1;i>0;i--))
do
  nmbin=${nmbin}1
done
for ((i=32-$1;i>0;i--))
do
  nmbin=${nmbin}0
done
echo ${nmbin}
}

gethostcount() {
local hostbits=$((32-${NM}))
local hosts=$((2**${hostbits}-2))
echo ${hosts}
}
getnetmask() {
netmask=$(netmasktobin ${NM})
netmask=$(bintoip ${netmask})
echo ${netmask}
}

getfirstlast() {
local ip=$1
local netmask=$2
local netbc=$3
ip=$(iptobin $(cleanip ${ip}))
ip=${ip:0:netmask}
for ((i=${netmask};i<32;i++))
do
  ip=${ip}${netbc}
done
ip=$(bintoip ${ip})
echo ${ip}
}

getnetaddress() {
getfirstlast $1 $2 0
}

getbroadcast() {
getfirstlast $1 $2 1
}

bintoip() {
local ip=""
ipbin=$1
ip="$((2#${ipbin:0:8}))"
ip=${ip}\."$((2#${ipbin:8:8}))"
ip=${ip}\."$((2#${ipbin:16:8}))"
ip=${ip}\."$((2#${ipbin:24:8}))"
echo ${ip}
}


IP=$(cleanip $(separateip ${CIDR}))
NM=$(separatenetmask ${CIDR})

echo "IP Address: ${IP}"
echo "Subnetmask: $(getnetmask ${NM})"
echo "Network ID: $(getnetaddress ${IP} ${NM})"
echo "Broadcast : $(getbroadcast ${IP} ${NM})"
echo "# of hosts: $(gethostcount ${NM})"
