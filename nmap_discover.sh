#!/bin/sh

echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fXyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgX19fXyAgX19fXyBfX18gIF9fX18gX19fX18gICAgICBfX19fLyAoXylfX19fX19fX19fX19fIF8gICBfX19fXyAgX19fX18KICAvIF9fIFwvIF9fIGBfXyBcLyBfXyBgLyBfXyBcICAgIC8gX18gIC8gLyBfX18vIF9fXy8gX18gXCB8IC8gLyBfIFwvIF9fXy8KIC8gLyAvIC8gLyAvIC8gLyAvIC9fLyAvIC9fLyAvICAgLyAvXy8gLyAoX18gICkgL19fLyAvXy8gLyB8LyAvICBfXy8gLyAgICAKL18vIC9fL18vIC9fLyAvXy9cX18sXy8gLl9fXy9fX19fXF9fLF8vXy9fX19fL1xfX18vXF9fX18vfF9fXy9cX19fL18vICAgICAKICAgICAgICAgICAgICAgICAgICAgL18vICAgL19fX19fLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA=" | base64 -d
echo '\n'

# set variables
fileflag="-iL"
userinput="${1}"

# check if user is running as root
if [ `id -u` != 0 ]
then
	echo "[\033[91mERROR\033[0m] Must be run as root. Usage: sudo ${0} [IP or FILE]\n"
	exit 1
fi

# check for a valid input file or string
if [ "$1" = '' ]
then
	echo "[\033[91mERROR\033[0m] No input target or file found. Usage: sudo ${0} [IP or FILE]\n"
	exit 1
fi

# check if the param is a file or string and assign to the 'flag' variable appropriately
if [ -f $1 ]
then
	target="${fileflag} ${userinput}"
	echo "[-] File input processed..."
else
	target="${userinput}"
	echo "[-] Single input processed..."
fi

# run ping probes
echo "[-] Performing Discovery..."
echo "    [-] ICMP Echo"
nmap -T4 -sn -PE $target -oA discovery_icmp_echo > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_icmp_echo.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] ICMP Echo [\033[92m${count}\033[0m]"
echo "    [-] ICMP Netmask"
nmap -T4 -sn -PM $target -oA discovery_icmp_netmask > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_icmp_netmask.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] ICMP Netmask [\033[92m${count}\033[0m]"
echo "    [-] ICMP Timestamp"
nmap -T4 -sn -PP $target -oA discovery_icmp_timestamp > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_icmp_timestamp.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] ICMP Timestamp [\033[92m${count}\033[0m]"
echo "    [-] ICMP Protocol"
nmap -T4 -sn -PO $target -oA discovery_ip_protocol > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_ip_protocol.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] ICMP Protocol [\033[92m${count}\033[0m]"

# run port discovery
echo "    [-] TCP SYN"
nmap -T4 -sn -PS21,22,53,80,443,8080,8443 $target -oA discovery_ip_tcpsyn > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_ip_tcpsyn.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] TCP SYN [\033[92m${count}\033[0m]"
echo "    [-] UDP..."
nmap -T4 -sn -PU53,161,500 $target -oA discovery_ip_udp > /dev/null 2>&1
tput cuu1 && tput el
count=$(tail -n 1 discovery_ip_udp.gnmap | grep -Po '(?<=\().{1,}(?=\))')
echo "    [\033[92m*\033[0m] UDP [\033[92m${count}\033[0m]"

#parse out results
echo "[-] Parsing Results..."
grep Up discovery*.gnmap | grep -Po '(?<= )([0-9]{1,3}\.){3}[0-9]{1,3}(?= )' | sort -u -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n > live_ips
echo "    [\033[92m*\033[0m] `wc -l < live_ips` unique IPs found and written to file [\033[92mlive_ips\033[0m]."
grep Up discovery*.gnmap | grep -Po '(?<=\().{1,}(?=\))' | sort -u > live_fqdns
echo "    [\033[92m*\033[0m] `wc -l < live_fqdns` unique FQDNs found and written to file [\033[92mlive_fqdns\033[0m]."